process fastqc {
    debug true
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
    echo $read1
    echo $read2
	"""
}