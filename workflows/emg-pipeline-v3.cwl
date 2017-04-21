cwlVersion: v1.0
class: Workflow
label: EMG pipeline description in CWL
doc: |
     Current steps include FragGeneScan (Fgs) and InterProScan (Ips).

requirements:
 - $import: ../tools/FragGeneScan1_20-types.yaml
 - $import: ../tools/InterProScan5.21-60-types.yaml

inputs:
  FgsInputFile:
    type: File
    doc: FragGeneScan input file
  FgsTrainDir: Directory
  FgsTrainingName: string
  FgsThreads:
    type: int?
    doc: FragGeneScan number of threads
  IpsApps: ../tools/InterProScan5.21-60-types.yaml#apps[]?
  IpsType: ../tools/InterProScan5.21-60-types.yaml#protein_formats
  FgsLength: boolean

outputs:
  annotations:
    type: File
    outputSource: interproscan/i5Annotations

steps:
  fraggenescan:
    run: ../tools/FragGeneScan1_20.cwl
    in:
      sequence: FgsInputFile
      completeSeq: FgsLength
      trainingName: FgsTrainingName
      threadNumber: FgsThreads
      trainDir: FgsTrainDir
    out: [predictedCDS]

  interproscan:
    run: ../tools/InterProScan5.21-60.cwl
    in:
      proteinFile: fraggenescan/predictedCDS
      applications: IpsApps
      outputFileType: IpsType
    out: [i5Annotations]
