process fastqc {
    debug true
    machineType 'n1-standard-2'
    tag "FastQC"
    label "fastqc"
    publishDir "${params.outdir}", mode: 'copy',
    saveAs: {filename ->
           if (filename.indexOf("html") > 0)              "fastqc/$filename"
      else if (filename.indexOf("zip") > 0)               "fastqc/$filename"
      else null
    }

    input:
    tuple val(sample_id), path(read1), path(read2), val(strand)

    output:
    tuple val(projects_name), path("*_fastqc.{zip,html}"), emit: fastqc_resutl

    script:
	"""
    fastqc --quiet ${reads}/* --outdir .
	"""



}