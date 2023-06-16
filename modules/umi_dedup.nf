process umi_dedup {
    debug true
    machineType 'e2-standard-2'
    container 'quay.io/biocontainers/umi_tools:1.1.4--py38hbff2b2d_1'
    tag "deduplication"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.endsWith("umi_dedup.sorted.bam"))              "umi/dedup/$filename"
      else null
    }

    when:
    !params.skip_umi_dedup

    input:
    tuple val(sample_id), path(bam), path(bai)

    output:
    tuple val(sample_id), path("${sample_id}.umi_dedup.sorted.bam"), emit: umi_dedup_result

    script:
	"""
    umi_tools dedup \
        -I $bam \
        -S ${sample_id}.umi_dedup.sorted.bam \
        --paired --unpaired-reads=discard \
        --chimeric-pairs=discard \
        --method='directional' \
        --umi-separator='_' \
        --random-seed=100
	"""
}