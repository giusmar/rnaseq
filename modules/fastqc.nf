process fastqc {
    debug true
    machineType 'e2-standard-4'
    container 'quay.io/biocontainers/fastqc:0.11.9--0'
    tag "FastQC"
    label "test"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("html") > 0)              "fastqc/$filename"
      else if (filename.indexOf("zip") > 0)               "fastqc/$filename"
      else null
    }

    input:
    tuple val(sample_id), path(read1), path(read2), val(strand)

    output:
    path("*_fastqc.{zip,html}"), emit: fastqc_resutl

    script:
	"""
    fastqc --quiet --threads 4 $read1 $read2
	"""
}