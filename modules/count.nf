process count_exon {
    debug true
    machineType 'e2-standard-16'
    container 'genomicpariscentre/subread:latest'
    tag "exom"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("umi_dedup") >0)              "count/$filename"
      else if (filename.indexOf("summary") >0)              "count/summary/$filename"
      else null
    }

    input:
    path(umi_dedup_bams)
    path(gtf)

    output:
    path("counts.umi_dedup.exon.txt"), emit: counts
    path("counts.umi_dedup.exon.log"), emit: counts_log
    path("*summary*"), emit: counts_summary


    script:
	"""
    featureCounts -T 15 -s 1 -p -a $gtf -t 'exon' -o counts.umi_dedup.exon.txt $umi_dedup_bams 2> counts.umi_dedup.exon.log
	"""
}

process count_gene {
    debug true
    machineType 'e2-standard-16'
    container 'genomicpariscentre/subread:latest'
    tag "gene"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("umi_dedup") >0)              "count/$filename"
      else if (filename.indexOf("summary") >0)              "count/summary/$filename"
      else null
    }

    input:
    path(umi_dedup_bams)
    path(gtf)

    output:
    path("counts.umi_dedup.gene.txt"), emit: counts
    path("counts.umi_dedup.gene.log"), emit: counts_log
    path("*summary*"), emit: counts_summary


    script:
	"""
    featureCounts -T 15 -s 1 -p -a $gtf -t 'gene' -o counts.umi_dedup.gene.txt $umi_dedup_bams 2> counts.umi_dedup.gene.log
	"""
}