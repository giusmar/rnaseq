nextflow.enable.dsl=2

//modules
include { fastqc } from './modules/fastqc'
include { umi_extract } from './modules/umi_extract'
include { trimming } from './modules/trimming'
include { align } from './modules/align'
include { umi_dedup } from './modules/umi_dedup'
include { count } from './modules/count'

// check
if (params.input) { input_ch = file(params.input, checkIfExists: true) } else { exit 1, 'Input samplesheet not specified!' }
if (params.genome) { genome_ch = file(params.genome, checkIfExists: true) } else { exit 1, 'Genome fasta not specified!' }
if (params.genomedir) { genomedir_ch = file(params.genomedir, checkIfExists: true) } else { exit 1, 'STAR Genome Directory not specified!' }
if (params.gtf) { gtf_ch = file(params.gtf, checkIfExists: true) } else { exit 1, 'GTF not specified!' }

inputPairReads = Channel.fromPath(input_ch)
                            .splitCsv( header:false, sep:',' )
                            .map( { row -> [sample_id = row[0], fastq1 = row[1], fastq2 = row[2], strand = row[3]] } )
genDir = Channel.fromPath(genomedir_ch)
                    .collect()
gtfile = Channel.fromPath(gtf_ch)
genomefile = Channel.fromPath(genome_ch)

workflow {
    fastqc(inputPairReads)
    umi_extract(inputPairReads)
    trimming(umi_extract.out.umi_extract_resutl)
    align(trimming.out.trimming_result,genDir.collect(),genomefile.collect(),gtfile.collect())
    umi_dedup(align.out.align_sorted_result)
    count(umi_dedup.out.umi_dedup_result.collect(it[1]),gtfile)
}
