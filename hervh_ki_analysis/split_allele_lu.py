#!/usr/bin/python

#########################################
# Author: Yunjiang Qiu <serein927@gmail.com>
# File: split_allele.py
# Create Date: 2017-05-15 13:48:57
#########################################

import sys
import argparse
import pysam

def load_vcf(vcf):
    chrom = ""
    snp = {}
    with open(vcf, 'r') as f:
        for line in f:
            if line[0] == '#':
                continue
            tmp = line.rstrip().split("\t")
            if chrom == "":
                chrom = tmp[0]
            elif chrom != tmp[0]:
                sys.exit("More than one chromosomes present %s and %s in the vcf file.\n" % (chrom, tmp[0]))
            if len(tmp[3]) > 1 or len(tmp[4]) > 1: # Ignore indels and multi-allelic SNPs
                continue
            try:
                gt = tmp[9].split(':')[tmp[8].split(':').index('GT')]
            except ValueError:
                sys.exit("Cannot find genotype for SNPs %s.\n" % line)
            if gt == "0/1":
                pass #unphased SNPs
            elif gt == "0|1" or gt == "1|0": # Het SNPs
                p1, p2 = gt.split("|")
                key = int(tmp[1])
                if key in snp:
                    sys.exit("Redundant SNP %s in the vcf file.\n" % key)
                if p1 == "0" and p2 == "1":
                    snp[key] = (tmp[3], tmp[4])
                else:
                    snp[key] = (tmp[4], tmp[3])
            else:
                sys.stderr.write("Unreconized genotype %s for SNP %s.\n" % (gt, key))
    return snp, chrom

def process_read(read, snp, mbq):
    het_count = {}
    ref_pos = read.reference_start + 1
    #sys.stderr.write("%s\t%d\n" % (read.query_name, ref_pos) )
    read_pos = 0
    for operation, length in read.cigartuples:
        #sys.stderr.write("%s\t%d\t%d\n" % (read.query_name, operation, length) )
        if operation == 0: # M: Match
            for i in range(length):
                if ref_pos in snp and read.query_qualities[read_pos] >= mbq:
                        base = read.query_sequence[read_pos].upper()
                        if base == snp[ref_pos][0]:
                            het_count[ref_pos] = 0
                        elif base == snp[ref_pos][1]:
                            het_count[ref_pos] = 1
                        else:
                            het_count[ref_pos] = 2
                        #sys.stderr.write("%s\t%d\t%d\t%s\n" % (read.query_name, ref_pos, read_pos, read.query_sequence[read_pos].upper()) )
                read_pos += 1
                ref_pos += 1
        elif operation == 1: # I: Insertion
            read_pos += length
        elif operation == 2: # D: Deletion
            ref_pos += length
        elif operation == 3: # N: Skip
            ref_pos += length
        elif operation == 4: # S: Soft Clip
            read_pos += length
        elif operation == 5: # H: Hard Clip
            pass
        else:
            sys.stderr.write("Unreconized cigar type %s for read %s.\n" % (read.cigarstring, read.query_name))
            return {}
    return het_count

def merge_fragment(read1, read2, snp, mbq):
    if read1.query_name != read2.query_name:
        sys.exit("%s and %s is not from the same pair!\n" % (read1.query_name, read2.query_name))
    het_count1 = process_read(read1, snp, mbq)
    het_count2 = process_read(read2, snp, mbq)
    base_overlap = het_count1.viewkeys() & het_count2.viewkeys()

    for ref_pos in base_overlap: #remove overlap bases that are not consistent
        if het_count1[ref_pos] != het_count2[ref_pos]:
            sys.stderr.write("Conflicting bases for %s at %d: %s and %s\n" % (read1.query_name, ref_pos, het_count1[ref_pos], het_count2[ref_pos]))
            het_count1.pop(ref_pos)
            het_count2.pop(ref_pos)

    het_count1.update(het_count2)

    return het_count1

def assign_allele(het_count):
    alleles = set(val for val in het_count.values())

    if len(alleles) == 0: #non-allelic
        return -2
    elif len(alleles) == 1: #cis
        return alleles.pop()
    elif len(alleles) == 2 and 1 in alleles and 0 in alleles: #trans
        return -1
    else: #misc
        return 2

def main():
    parser = argparse.ArgumentParser(description='')
    parser.add_argument("-b", "--bam", dest="bam", required=True, help="bam file")
    parser.add_argument("-v", "--vcf", dest="vcf", required=True, help="vcf file")
    parser.add_argument("-o", "--out", dest="out", required=True, help="output prefix")
    parser.add_argument("--mmq", dest="mmq", default=20, type=int, help="minimum mapping quality")
    parser.add_argument("--mbq", dest="mbq", default=13, type=int, help="minimum base quality")
    args = parser.parse_args()

    mmq = args.mmq
    mbq = args.mbq

    sys.stderr.write("Extract het SNPs counts in vcf file %s for bam file %s.\nMinimum mapping quality is %d, and minimum base quality is %d.\n" % (args.vcf, args.bam, mmq, mbq) )

    snp, chrom = load_vcf(args.vcf)
    sys.stderr.write("Read %d het SNPs for chromosome %s.\n" % (len(snp), chrom) )

    bamfile = pysam.AlignmentFile(args.bam,"rb")
    bamfile_p1 = pysam.AlignmentFile(args.out + "Aallele.bam", "wb", template=bamfile)
    bamfile_p2 = pysam.AlignmentFile(args.out + "Ballele.bam", "wb", template=bamfile)

    reads = {}
    reads_low_mapq = set()
    count_low_mapq = 0
    count_non = 0
    count_a = 0
    count_b = 0
    count_trans = 0
    count_misc = 0
    count_double = 0
    read_count = 0

    for read in bamfile:
        if read.reference_id < 0 or read.reference_id > 25 : 
           # sys.stderr.write("noep\n")
            continue
        if bamfile.get_reference_name(read.reference_id) != chrom:
           # sys.stderr.write("Hey! Chromsome in the bam file %s is not the same as in the vcf file %s.\n" % (read.query_sequence, chrom))
            continue
            #sys.exit("Chromsome in the bam file %s is not the same as in the vcf file %s.\n" % (read.query_sequence, chrom) )
        if read.query_name in reads_low_mapq:
            continue
        if read.mapping_quality < mmq:
            read_count += 1
            count_low_mapq += 1
            reads_low_mapq.add(read.query_name)
            continue
        if read.is_paired:
            if read.query_name in reads:
                het_count = merge_fragment(reads[read.query_name], read, snp, mbq)
                allele = assign_allele(het_count)
                if allele == 0:
                    bamfile_p1.write(reads[read.query_name])
                    bamfile_p1.write(read)
                    count_a += 1
                elif allele == 1:
                    bamfile_p2.write(reads[read.query_name])
                    bamfile_p2.write(read)
                    count_b += 1
                elif allele == -2:
                    count_non += 1
                elif allele == -1:
                    count_trans += 1
                elif allele == 2:
                    count_misc += 1
                    sys.stderr.write("Misc alleles in read %s.\n" % read.query_name)
                else:
                    sys.exit("Unrecoginized allele %d for %s.\n" % (allele, read.query_name) )
                if len(het_count) >= 2 and allele != 2:
                    count_double += 1
                reads.pop(read.query_name, 'None')
            else:
                read_count += 1
                reads[read.query_name] = read
        else:
            read_count += 1
            het_count = process_read(read, snp, mbq)
            allele = assign_allele(het_count)
            if allele == 0:
                count_a += 1
                bamfile_p1.write(read)
            elif allele == 1:
                bamfile_p2.write(read)
                count_b += 1
            elif allele == -2:
                count_non += 1
            elif allele == -1:
                count_trans += 1
            elif allele == 2:
                count_misc += 1
                sys.stderr.write("Misc alleles in read %s.\n" % read.query_name)
            else:
                sys.exit("Unrecoginized allele %d for %s.\n" % (allele, read.query_name) )
            if len(het_count) >= 2 and allele != 2:
                count_double += 1

    sys.stderr.write("Processed %d reads.\n" % read_count)
    sys.stderr.write("%s\n" % "\t".join([str(i) for i in [read_count, count_a, count_b, count_non, count_trans, count_misc, count_low_mapq, count_double] ]))

    for read_name in reads: # Cleanup singleton reads
        if read_name in reads_low_mapq:
            read_count -= 1
            continue
        read = reads[read_name]
        het_count = process_read(read, snp, mbq)
        allele = assign_allele(het_count)
        if allele == 0:
            bamfile_p1.write(read)
            count_a += 1
        elif allele == 1:
            bamfile_p2.write(read)
            count_b += 1
        elif allele == -2:
            count_non += 1
        elif allele == -1:
            count_trans += 1
        elif allele == 2:
            count_misc += 1
            sys.stderr.write("Misc alleles in read %s.\n" % read.query_name)
        else:
            sys.exit("Unrecoginized allele %d for %s.\n" % (allele, read.query_name) )
        if len(het_count) >= 2 and allele != 2:
            count_double += 1

    sys.stderr.write("Cleaned %d unpaired reads.\n" % len(reads))
    sys.stderr.write("%s\n" % "\t".join([str(i) for i in [read_count, count_a, count_b, count_non, count_trans, count_misc, count_low_mapq, count_double] ]))

if __name__ == "__main__":
    sys.exit(main())

