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

    when:
    !params.skip_count_exon

    input:
    path(umi_dedup_bams)
    path(gtf)

    output:
    path("counts*exon.txt"), emit: counts
    path("counts*exon.log"), emit: counts_log
    path("*summary*"), emit: counts_summary


    script:
    def umi = params.thereisumi ? 'umi_dedup.' : ''
	"""
    featureCounts -T 15 -s $params.strand -p -a $gtf -t 'exon' -o counts.${umi}exon.txt $umi_dedup_bams 2> counts.${umi}exon.log
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

    when:
    !params.skip_count_gene

    input:
    path(umi_dedup_bams)
    path(gtf)

    output:
    path("counts*gene.txt"), emit: counts
    path("counts*gene.log"), emit: counts_log
    path("*summary*"), emit: counts_summary


    script:
    def umi = params.thereisumi ? 'umi_dedup.' : ''
	"""
    featureCounts -T 15 -s $params.strand -p -a $gtf -t 'gene' -o counts.${umi}gene.txt $umi_dedup_bams 2> counts.${umi}gene.log
	"""
}