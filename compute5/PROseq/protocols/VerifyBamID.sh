#MOLGENIS walltime=23:59:00 nodes=1 mem=4gb ppn=1

### variables to help adding to database (have to use weave)
#string sampleName
#string project
###
#string verifyBamIdDir
#string unifiedGenotyperDir
#string sortedBam
#string sortedBai
#string uniqueID
#string verifyBamIDVersion
#string stage
#string checkStage


#Load modules
${stage} verifyBamID/${verifyBamIDVersion}

#check modules
${checkStage}

mkdir -p ${verifyBamIdDir}

echo "## "$(date)" Start $0"
echo "ID (project-sampleName): ${project}-${sampleName}"

if verifyBamID \
  --vcf ${indelRealignmentBam} \
  --bam ${sortedBam} \
  --out ${verifyBamIdDir}${uniqueID}

then
 echo "returncode: $?";
 cd ${verifyBamIdDir}
 md5sum $(basename ${verifyBamIdDir}${uniqueID}.depthSM) > $(basename ${verifyBamIdDir}${uniqueID}).depthSM.md5
 md5sum $(basename ${verifyBamIdDir}${uniqueID}).log > $(basename ${verifyBamIdDir}${uniqueID}).log.md5
 md5sum $(basename ${verifyBamIdDir}${uniqueID}).selfRG > $(basename ${verifyBamIdDir}${uniqueID}).selfRG.md5
 md5sum $(basename ${verifyBamIdDir}${uniqueID}).selfSM > $(basename ${verifyBamIdDir}${uniqueID}).selfSM.md5
 md5sum $(basename ${verifyBamIdDir}${uniqueID}).depthRG > $(basename ${verifyBamIdDir}${uniqueID}).depthRG.md5
 cd -
echo "succes moving files";
else
 echo "returncode: $?";
 echo "fail";
fi

echo "## "$(date)" ##  $0 Done "
