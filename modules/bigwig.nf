process bigwig {
    debug true
    machineType 'e2-standard-4'
    container 'dukegcb/deeptools:2.2.4'
    tag "bigwig"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("bw") > 0)              "bigwig/$filename"
      else null
    }

    input:
    tuple val(sample_id), path(umi_dedup_bam)

    output:
    tuple val(sample_id), path("${sample_id}.coverage.bw"), emit: bigwig

    script:
	"""
    samtools index $umi_dedup_bam
    bamCoverage -b $umi_dedup_bam -o ${sample_id}.coverage.bw
	"""
}
