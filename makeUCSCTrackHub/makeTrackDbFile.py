import sys

stage_code = {
  "D00": "255,0,0",
  "D02": "255,127,0",
  "D05": "0,255,0",
  "D07": "0,0,255",
  "D15": "75,0,130",
  "D80": "148,0,211"
  }

marker_code = {
  "ATAC": "255,0,0",
  "H3K27ac": "255,127,0",
  "H3K4me1": "0,255,0",
  "H3K4me3": "0,0,255",
  "H3K27me3": "75,0,130",
  "rnaseq": "0,0,0",
  "Input": "122,122,122"
  }

score_positive = "255,0,0"
score_negative = "0,0,255"

def writeEachStage(outfile, marker, stage):
  strs = ["",
  "track " + marker + "_" + stage ,
  "bigDataUrl " + marker + "_" + stage + ".rpkm.bw" , 
  "shortLabel " + marker + "_" + stage ,
  "longLabel " + marker + "_" + stage ,
  "parent " + marker ,
  "graghTypeDefault bar" ,
  "type bigWig" , 
  "color " + marker_code[marker]
  ] 
  strs = "\n    ".join(strs) +"\n"
  outfile.write(strs)
  return

def writeEachStageRep(outfile, score, rep, stage):
  strs = ["",
  "track " + score + "_" + stage + rep ,
  "bigDataUrl " + score + "." + stage + rep + ".bw" ,
  "shortLabel " + score + "_" + stage + rep,
  "longLabel " + score + "_" + stage + rep,
  "parent " + score,
  "graghTypeDefault bar" ,
  "type bigWig",
  "color " + score_positive,
  "altColor " + score_negative,
  ]
  strs = "\n    ".join(strs) +"\n"
  outfile.write(strs)
  return


def makeMultiWigGroup(outfile, marker):
    strs = ["###############",
    "track " + marker,
    "type bigWig",
    "container multiWig",
    "shortLabel " + marker +" multiWig container",
    "longLabel " +  marker +" multiWig container",
    "visibility full",
    "aggregate none",
    "showSubtrackColorOnUi on",
    "maxHeightPixels 80:32:8",
    "autoScale on",
    "html examplePage",
    ""]
    outfile.write("\n".join(strs))
    for stage in ["D00","D02","D05","D07","D15","D80"]:
        writeEachStage(outfile, marker, stage)
    outfile.write("\n")
    return


def makeBedGraphGroup(outfile, score):
    strs = ["###############",
    "track " + score,
    "type bigWig",
    "container multiWig",
    "shortLabel " + score +" multiWig container",
    "longLabel " +  score +" multiWig container",
    "visibility full",
    "aggregate none",
    "showSubtrackColorOnUi on",
    "maxHeightPixels 40:16:4",
    "autoScale on",
    "html examplePage",
    ""]
    outfile.write("\n".join(strs))
    for stage in ["D00","D02","D05","D07","D15","D80"]:
        for rep in [".rep1",".rep2"]:
            writeEachStageRep(outfile, score, rep, stage)
    outfile.write("\n")
    return 


if __name__ == "__main__":
#  if len(sys.argv) != 2:
#    print("usage: %prog path2trackDb.txt")
#    exit(1)
#  else: 
#    outfile = sys.argv[1]
    outfile = "../../data/trackhub/hg19/trackDb.txt"
    with open(outfile,'w') as f:
        makeMultiWigGroup(f,"ATAC")
        makeMultiWigGroup(f,"H3K27ac")
        makeMultiWigGroup(f,"H3K27me3")
        makeMultiWigGroup(f,"H3K4me1")
        makeMultiWigGroup(f,"H3K4me3")
        makeMultiWigGroup(f,"rnaseq")
        makeMultiWigGroup(f,"Input")
        makeBedGraphGroup(f,"DI")
        makeBedGraphGroup(f,"Insulation")
        makeBedGraphGroup(f,"PC1")


