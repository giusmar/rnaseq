process align {
    debug true
    machineType 'e2-standard-2'
    container 'quay.io/biocontainers/mulled-v2-1fa26d1ce03c295fe2fdcf85831a92fbcbd7e8c2:1df389393721fc66f3fd8778ad938ac711951107-0'
    tag "align"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("_extract_") > 0)              "umi_extract/fastq/$filename"
      else if (filename.indexOf("log") > 0)               "umi_extract/logs/$filename"
      else null
    }

    input:
    tuple val(sample_id), path(trimmed_1), path(trimmed_2)
    path(genDir)
    path(gtf)

    output:
    tuple val(sample_id), path("*bam"), path("*bam.bai"), emit: align_result

    script:
	"""
    echo "fatto"
	"""
}