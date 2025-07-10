nextflow.enable.dsl=2

params.sample = ''
params.data_root_dir = ''
params.tile_size = 250
params.image_tile_layer = 'all'
params.landscape_files = ''

workflow {
    ch_inputs = Channel.of([
        params.sample,
        file(params.data_root_dir),
        params.tile_size.toString(),
        params.image_tile_layer,
        params.landscape_files  // Pass as path input to stage directory
    ])

    run_dega_pre(ch_inputs)
}

process run_dega_pre {
    conda = 'environment.yml'
    publishDir "results/${params.sample}", mode: 'copy'

    input:
    tuple val(sample), path(data_root_dir), val(tile_size), val(image_tile_layer), val(landscape_files)

    script:
    """
    python3 -c "
import celldega as dega

dega.pre.main(
    sample='${sample}',
    data_root_dir='${data_root_dir}',
    tile_size=${tile_size},
    image_tile_layer='${image_tile_layer}',
    path_landscape_files='${landscape_files}',
    use_int_index=True,
)
"
    """
}
