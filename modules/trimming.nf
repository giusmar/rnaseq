process trimming {
    debug true
    machineType 'e2-standard-8'
    container 'quay.io/biocontainers/trim-galore:0.6.7--hdfd78af_0'
    tag "trimming"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("gz") > 0)              "trimming/fastq/$filename"
      else if (filename.indexOf("html") > 0)              "trimming/fastqc/$filename"
      else if (filename.indexOf("zip") > 0)              "trimming/fastqc/$filename"
      else null
    }
    
    when:
    !params.skip_trimming

    input:
    tuple val(sample_id), path(extract_1), path(extract_2), val(strand)

    output:
    tuple val(sample_id), path("*1.fq.gz"), path("*2.fq.gz*"), emit: trimming_result
    tuple val(sample_id), path("*html"), path("*zip"), emit: trimming_fastqc

    script:
	"""
    trim_galore \
        --fastqc \
        --fastqc_args '-t 8' \
        --cores 8 \
        --gzip \
        --paired \
        $extract_1 $extract_2
	"""
}
