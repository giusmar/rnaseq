process count {
    debug true
    machineType 'e2-standard-4'
    container 'quay.io/biocontainers/umi_tools:1.1.4--py38hbff2b2d_1'
    tag "count"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("umi_dedup") >0)              "count/$filename"
      else null
    }

    input:
    path(umi_dedup_bams)
    path(gtf)

    output:
    path("*txt"), emit: counts
    path("*log"), emit: counts_log


    script:
	"""
    featureCounts -T 4 -s 1 -p -a $gtf -o counts.umi_dedup.txt $umi_dedup_bams 2> counts.umi_dedup.log
	"""
}