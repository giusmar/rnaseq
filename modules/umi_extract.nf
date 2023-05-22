process umi_extract {
    debug true
    machineType 'e2-standard-2'
    container 'quay.io/biocontainers/umi_tools:1.1.4--py38hbff2b2d_1'
    tag "umi_extract"
    disk "100 GB"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("_extract_") > 0)              "umi/extract/fastq/$filename"
      else if (filename.endsWith("log"))               "umi/extract/logs/$filename"
      else null
    }

    input:
    tuple val(sample_id), path(read1), path(read2), val(strand)

    output:
    tuple val(sample_id), path("*extract_1*"), path("*extract_2*"), emit: umi_extract_resutl
    tuple val(sample_id), path("*umi_extract*"), emit: umi_extract_log

    script:
	"""
    umi_tools extract \
        -I $read1 --read2-in=$read2 \
        -S ${sample_id}.umi_extract_1.fastq.gz --read2-out=${sample_id}.umi_extract_2.fastq.gz \
        --extract-method=string --bc-pattern='NNNNNNNNNNNN' > ${sample_id}.umi_extract.log
	"""
}
