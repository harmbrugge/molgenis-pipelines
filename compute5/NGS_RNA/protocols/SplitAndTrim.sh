#MOLGENIS nodes=1 ppn=8 mem=8gb walltime=23:59:00

#string project
#string stage
#string checkStage
#string sampleMergedBam
#string sampleMergedBai
#string samtoolsVersion
#string gatkVersion
#string intermediateDir
#string	externalSampleID
#string splitAndTrimBam
#string splitAndTrimBai
#string tmpDataDir
#string indexFile
#string tmpTmpDataDir

makeTmpDir ${splitAndTrimBam} 
tmpsplitAndTrimBam=${MC_tmpFile}

#Load Modules
${stage} ${gatkVersion}
${stage} ${samtoolsVersion}

#check modules
${checkStage}

echo "## "$(date)" Start $0"

echo
echo "## Action to perform in quals: "$qualAction" ##"
echo
echo "Running split and trim:"
if java -Xmx8g -XX:ParallelGCThreads=8 -Djava.io.tmpdir=${tmpTmpDataDir} -jar ${EBROOTGATK}/GenomeAnalysisTK.jar \
 -T SplitNCigarReads \
 -R ${indexFile} \ 
 -I ${sampleMergedBam} \ 
 -o ${tmpsplitAndTrimBam} \ 
 -rf ReassignOneMappingQuality \
 -RMQF 255 \
 -RMQT 60 \
 -U ALLOW_N_CIGAR_READS

then
	mv ${tmpsplitAndTrimBam} ${splitAndTrimBam}
    	echo "returncode: $?";
        echo "succes moving files";
else
 echo "returncode: $?";
 echo "fail";
fi

echo "## "$(date)" ##  $0 Done "

