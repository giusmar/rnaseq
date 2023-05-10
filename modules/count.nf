process count {
    debug true
    machineType 'e2-standard-4'
    container '	quay.io/biocontainers/umi_tools:1.1.4--py38hbff2b2d_1'
    tag "count"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("umi_dedup") >0)              "count/$filename"
      else null
    }

    input:
    tuple val(sample_id), path(umi_dedup_bam)
    path(gtf)

    output:
    path("counts.umi_dedup.txt"), emit: counts
    path("counts.umi_dedup.log"), emit: counts_log


    script:
	"""
    featureCounts -T 4 -s 1 -p -a $gtf -o counts.umi_dedup.txt $umi_dedup_bam 2> counts.umi_dedup.log
	"""
}