

process RECONST_MEANFRF {
    label 'process_single'

    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://scil.usherbrooke.ca/containers/scilus_1.6.0.sif':
        'scilus/scilus:1.6.0' }"

    input:
        tuple path(frf_list)

    output:
        path("mean_frf.txt")                            , emit: meanfrf
        path "versions.yml"                             , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1
    export OMP_NUM_THREADS=1
    export OPENBLAS_NUM_THREADS=1

    scil_compute_mean_frf.py $frf_list mean_frf.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        scilpy: 1.6.0
    END_VERSIONS
    """

    stub:
    """
    scil_compute_mean_frf.py -h

    touch mean_frf.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        scilpy: 1.6.0
    END_VERSIONS
    """
}
