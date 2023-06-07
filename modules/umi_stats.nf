process umi_stats {
    debug true
    machineType 'e2-standard-4'
    container 'staphb/samtools:1.17'
    tag "bigwig"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("stats") > 0)              "umi/stats/$filename"
      else if (filename.indexOf("bai") > 0)                "umi/bam/$filename"
      else null
    }

    input:
    tuple val(sample_id), path(umi_dedup_bam)
    path(genDir)

    output:
    tuple val(sample_id), path("*bai"), emit: bai
    tuple val(sample_id), path("*stat*"), emit: stats

    script:
	"""
    samtools index -@ 4 $umi_dedup_bam
    samtools stats -@ 4 --reference $genDir/Genome $umi_dedup_bam > ${sample_id}.umi_dedup.sorted.bam.stats
    samtools flagstat -@ 4 $umi_dedup_bam > ${sample_id}.umi_dedup.sorted.bam.flagstat
    samtools idxstats -@ 4 $umi_dedup_bam > ${sample_id}.umi_dedup.sorted.bam.idxstats
	"""
}