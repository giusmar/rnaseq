process trimming {
    debug true
    machineType 'e2-standard-8'
    container 'quay.io/biocontainers/trim-galore:0.6.7--hdfd78af_0'
    tag "trimming"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("val*gz") > 0)              "trimming/fastq/$filename"
      else if (filename.indexOf("val*{html,zip}") > 0)              "trimming/fastqc/$filename"
      else null
    }

    input:
    tuple val(sample_id), path(extract_1), path(extract_2)

    output:
    tuple val(sample_id), path("*1_val_1*"), path("*2_val_2*"), emit: trimming_resutl

    script:
	"""
    ln -s $extract_1 ${sample_id}_1.fastq.gz
    ln -s $extract_1 ${sample_id}_2.fastq.gz
    trim_galore \
        --fastq_args "-t 8" \
        --cores 8 \
        --paired \
        --gzip \
        ${sample_id}_1.fastq.gz ${sample_id}_2.fastq.gz
	"""
}