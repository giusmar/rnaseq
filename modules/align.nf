process align {
    debug true
    machineType 'e2-highmem-16'
    container 'quay.io/biocontainers/mulled-v2-1fa26d1ce03c295fe2fdcf85831a92fbcbd7e8c2:1df389393721fc66f3fd8778ad938ac711951107-0'
    tag "align"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.endsWith("sorted.bam"))              "STAR/align/$filename"
      else if (filename.endsWith("sorted.bam.bai"))               "STAR/align/$filename"
      else if (filename.endsWith("out"))               "STAR/log/$filename"
      else if (filename.indexOf("stat") > 0)               "STAR/stat/$filename"
      else if (filename.indexOf("Unmapped") > 0)               "STAR/Unmapped/$filename"
      else null
    }

    input:
    tuple val(sample_id), path(trimmed_1), path(trimmed_2)
    path(genDir)
    path(genome)
    path(gtf)

    output:
    tuple val(sample_id), path("${sample_id}.Aligned.out.bam"), emit: align_result
    tuple val(sample_id), path("${sample_id}.sorted.bam"), path("${sample_id}.sorted.bam.bai"), emit: align_sorted_result
    tuple val(sample_id), path("*stat*"), emit: align_stat_result
    tuple val(sample_id), path("*Unmapped.out.mate*"), emit: align_unmapped
    tuple val(sample_id), path("*out"), emit: align_log

    script:
	"""
    STAR \
        --genomeDir $genDir \
        --readFilesIn $trimmed_1 $trimmed_2 \
        --runThreadN 15 \
        --outFileNamePrefix ${sample_id}. \
        --outSAMattrRGline ID:${sample_id} 'SM:${sample_id}' \
        --twopassMode Basic \
        --outSAMtype BAM Unsorted --readFilesCommand zcat \
        --runRNGseed 0 --outFilterMultimapNmax 20 \
        --alignSJDBoverhangMin 1 --outSAMattributes NH HI AS NM MD \
        --outReadsUnmapped Fastx

    samtools sort -@ 15 -o ${sample_id}.sorted.bam -T ${sample_id}.sorted ${sample_id}.Aligned.out.bam
    samtools index -@ 15 ${sample_id}.sorted.bam
    samtools stats -@ 15 --reference $genome ${sample_id}.sorted.bam > ${sample_id}.sorted.bam.stats
    samtools flagstat -@ 15 ${sample_id}.sorted.bam > ${sample_id}.sorted.bam.flagstat
    samtools idxstats -@ 15 ${sample_id}.sorted.bam > ${sample_id}.sorted.bam.idxstats
    """
}
