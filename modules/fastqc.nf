process fastqc {
    debug true
    machineType 'e2-standard-4'
    container 'quay.io/biocontainers/fastqc:0.11.9--0'
    tag "FastQC"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("html") > 0)              "fastqc/$filename"
      else if (filename.indexOf("zip") > 0)               "fastqc/$filename"
      else null
    }

    when:
    !params.skip_fastqc

    input:
    tuple val(sample_id), path(read1), path(read2), val(strand)

    output:
    path("*_fastqc.{zip,html}"), emit: fastqc_resutl

    script:
    """
    ln -s $read1 ${sample_id}_R1.fastq.gz
    ln -s $read2 ${sample_id}_R2.fastq.gz 
    fastqc --quiet --threads 4 ${sample_id}_R1.fastq.gz ${sample_id}_R2.fastq.gz
	"""
}