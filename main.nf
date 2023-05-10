nextflow.enable.dsl=2

//modules
include { fastqc } from './modules/fastqc'
include { umi_extract } from './modules/umi_extract'
//include { trimming } from './modules/trimming'
//include { align } from './modules/align'
//include { umi_dedup } from './modules/umi_dedup'

// check
if (params.input) { input_ch = file(params.input, checkIfExists: true) } else { exit 1, 'Input samplesheet not specified!' }

inputPairReads = Channel.fromPath(input_ch)
                            .splitCsv( header:false, sep:',' )
                            .map( { row -> [sample_id = row[0], fastq1 = row[1], fastq2 = row[2], strand = row[3]] } )

workflow {
    fastqc(inputPairReads)
    umi_extract(inputPairReads)
}
