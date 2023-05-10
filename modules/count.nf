process count {
    debug true
    machineType 'e2-standard-16'
    container 'genomicpariscentre/subread:latest'
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
    path("counts.umi_dedup.txt"), emit: counts
    path("counts.umi_dedup.log"), emit: counts_log


    script:
	"""
    featureCounts -T 15 -s 1 -p -a $gtf -o counts.umi_dedup.txt $umi_dedup_bams 2> counts.umi_dedup.log
	"""
}