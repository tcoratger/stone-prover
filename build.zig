const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var cpu_air_prover = b.addExecutable(.{ .name = "cpu_air_prover", .target = target, .optimize = optimize });
    cpu_air_prover.addCSourceFile(.{
        .file = .{ .path = "src/starkware/main/cpu/cpu_air_prover_main.cc" },
        .flags = &.{"-I./"},
    });
    cpu_air_prover.linkLibCpp();

    // BEGIN
    const algebra_lde = b.addStaticLibrary(.{
        .name = "algebra_lde",
        .target = target,
        .optimize = optimize,
    });
    algebra_lde.linkLibCpp();
    algebra_lde.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/algebra/lde/lde_test.cc",
        "src/starkware/algebra/lde/cached_lde_manager_test.cc",
        "src/starkware/algebra/lde/lde.cc",
        "src/starkware/algebra/lde/cached_lde_manager.cc",
    } });

    const algebra_fields = b.addStaticLibrary(.{
        .name = "algebra_fields",
        .target = target,
        .optimize = optimize,
    });
    algebra_fields.linkLibCpp();
    algebra_fields.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/algebra/fields/test_field_element_test.cc",
        "src/starkware/algebra/fields/long_field_element_test.cc",
        "src/starkware/algebra/fields/prime_field_element_test.cc",
        "src/starkware/algebra/fields/fraction_field_element_test.cc",
        "src/starkware/algebra/fields/extension_field_element_test.cc",
        "src/starkware/algebra/fields/field_operations_helper_test.cc",
        "src/starkware/algebra/fields/prime_field_element.cc",
        "src/starkware/algebra/fields/prime_field_element.cc",
        "src/starkware/algebra/fields/test_field_element.cc",
        "src/starkware/algebra/fields/long_field_element.cc",
    } });

    const algebra_fft = b.addStaticLibrary(.{
        .name = "algebra_fft",
        .target = target,
        .optimize = optimize,
    });
    algebra_fft.linkLibCpp();
    algebra_fft.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/algebra/fft/fft_test.cc",
        "src/starkware/algebra/fft/fft.cc",
    } });

    const algebra_utils = b.addStaticLibrary(.{
        .name = "algebra_utils",
        .target = target,
        .optimize = optimize,
    });
    algebra_utils.linkLibCpp();
    algebra_utils.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/algebra/utils/invoke_template_version_test.cc",
        "src/starkware/algebra/utils/name_to_field_test.cc",
        "src/starkware/algebra/utils/name_to_field.cc",
    } });

    const algebra_domains = b.addStaticLibrary(.{
        .name = "algebra_domains",
        .target = target,
        .optimize = optimize,
    });
    algebra_domains.linkLibCpp();
    algebra_domains.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/algebra/domains/multiplicative_group_test.cc",
        "src/starkware/algebra/domains/list_of_cosets_test.cc",
        "src/starkware/algebra/domains/list_of_cosets.cc",
        "src/starkware/algebra/domains/multiplicative_group.cc",
    } });

    const algebra_elliptic_curve = b.addStaticLibrary(.{
        .name = "algebra_elliptic_curve",
        .target = target,
        .optimize = optimize,
    });
    algebra_elliptic_curve.linkLibCpp();
    algebra_elliptic_curve.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/algebra/elliptic_curve/elliptic_curve_test.cc",
    } });

    const algebra_polymorphic = b.addStaticLibrary(.{
        .name = "algebra_polymorphic",
        .target = target,
        .optimize = optimize,
    });
    algebra_polymorphic.linkLibCpp();
    algebra_polymorphic.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/algebra/polymorphic/field_element_test.cc",
        "src/starkware/algebra/polymorphic/field_test.cc",
        "src/starkware/algebra/polymorphic/field_element_vector_test.cc",
        "src/starkware/algebra/polymorphic/field_element_span_test.cc",
        "src/starkware/algebra/polymorphic/field_element.cc",
        "src/starkware/algebra/polymorphic/field.cc",
        "src/starkware/algebra/polymorphic/field_element_vector.cc",
        "src/starkware/algebra/polymorphic/field_element_span.cc",
    } });

    const starkware_algebra = b.addStaticLibrary(.{
        .name = "starkware_algebra",
        .target = target,
        .optimize = optimize,
    });
    starkware_algebra.linkLibCpp();
    starkware_algebra.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/algebra/field_operations_test.cc",
        "src/starkware/algebra/field_operations_axioms_test.cc",
        "src/starkware/algebra/field_element_base_test.cc",
        "src/starkware/algebra/big_int_test.cc",
        "src/starkware/algebra/polynomials_test.cc",
        "src/starkware/algebra/field_to_int_test.cc",
    } });

    starkware_algebra.linkLibrary(algebra_domains);
    starkware_algebra.linkLibrary(algebra_elliptic_curve);
    starkware_algebra.linkLibrary(algebra_fft);
    starkware_algebra.linkLibrary(algebra_fields);
    starkware_algebra.linkLibrary(algebra_lde);
    starkware_algebra.linkLibrary(algebra_polymorphic);
    starkware_algebra.linkLibrary(algebra_utils);

    const starkware_stark = b.addStaticLibrary(.{
        .name = "starkware_stark",
        .target = target,
        .optimize = optimize,
    });
    starkware_stark.linkLibCpp();
    starkware_stark.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/stark/committed_trace_test.cc",
        "src/starkware/stark/composition_oracle_test.cc",
        "src/starkware/stark/oods_test.cc",
        "src/starkware/stark/stark_test.cc",
        "src/starkware/stark/stark_params_test.cc",
        "src/starkware/stark/committed_trace.cc",
        "src/starkware/stark/composition_oracle.cc",
        "src/starkware/stark/oods.cc",
        "src/starkware/stark/stark.cc",
        "src/starkware/stark/utils.cc",
    } });

    const main_cpu = b.addStaticLibrary(.{
        .name = "main_cpu",
        .target = target,
        .optimize = optimize,
    });
    main_cpu.linkLibCpp();
    main_cpu.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/main/cpu/cpu_air_prover_main.cc",
        "src/starkware/main/cpu/cpu_air_verifier_main.cc",
    } });

    const starkware_main = b.addStaticLibrary(.{
        .name = "starkware_main",
        .target = target,
        .optimize = optimize,
    });
    starkware_main.linkLibCpp();
    starkware_main.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/main/verifier_main_helper_impl.cc",
        "src/starkware/main/prover_main_helper_impl.cc",
        "src/starkware/main/prover_main_helper.cc",
        "src/starkware/main/verifier_main_helper.cc",
    } });

    starkware_main.linkLibrary(main_cpu);

    const crypt_tools_hash_context = b.addStaticLibrary(.{
        .name = "crypt_tools_hash_context",
        .target = target,
        .optimize = optimize,
    });
    crypt_tools_hash_context.linkLibCpp();
    crypt_tools_hash_context.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/crypt_tools/hash_context/pedersen_hash_context.cc",
    } });

    const starkware_crypt_tools = b.addStaticLibrary(.{
        .name = "starkware_crypt_tools",
        .target = target,
        .optimize = optimize,
    });
    starkware_crypt_tools.linkLibCpp();
    starkware_crypt_tools.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/crypt_tools/utils_test.cc",
        "src/starkware/crypt_tools/keccak_256_test.cc",
        "src/starkware/crypt_tools/masked_hash_test.cc",
        "src/starkware/crypt_tools/blake2s_test.cc",
        "src/starkware/crypt_tools/pedersen_test.cc",
        "src/starkware/crypt_tools/test_utils.cc",
    } });

    starkware_crypt_tools.linkLibrary(crypt_tools_hash_context);

    const starkware_gtest = b.addStaticLibrary(.{
        .name = "starkware_gtest",
        .target = target,
        .optimize = optimize,
    });
    starkware_gtest.linkLibCpp();
    starkware_gtest.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/gtest/gtest_main.cc",
    } });

    const commitment_scheme_merkle = b.addStaticLibrary(.{
        .name = "commitment_scheme_merkle",
        .target = target,
        .optimize = optimize,
    });
    commitment_scheme_merkle.linkLibCpp();
    commitment_scheme_merkle.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/commitment_scheme/merkle/merkle_test.cc",
        "src/starkware/commitment_scheme/merkle/merkle.cc",
        "src/starkware/commitment_scheme/merkle/merkle_commitment_scheme.cc",
    } });

    const starkware_commitment_scheme = b.addStaticLibrary(.{
        .name = "starkware_commitment_scheme",
        .target = target,
        .optimize = optimize,
    });
    starkware_commitment_scheme.linkLibCpp();
    starkware_commitment_scheme.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/commitment_scheme/table_prover_impl_test.cc",
        "src/starkware/commitment_scheme/parallel_table_prover_test.cc",
        "src/starkware/commitment_scheme/table_verifier_impl_test.cc",
        "src/starkware/commitment_scheme/packaging_commitment_scheme_test.cc",
        "src/starkware/commitment_scheme/commitment_scheme_test.cc",
        "src/starkware/commitment_scheme/caching_commitment_scheme_test.cc",
        "src/starkware/commitment_scheme/table_prover_impl.cc",
        "src/starkware/commitment_scheme/table_verifier_impl.cc",
        "src/starkware/commitment_scheme/table_impl_details.cc",
        "src/starkware/commitment_scheme/parallel_table_prover.cc",
        "src/starkware/commitment_scheme/packer_hasher.cc",
        "src/starkware/commitment_scheme/packaging_commitment_scheme.cc",
        "src/starkware/commitment_scheme/caching_commitment_scheme.cc",
    } });

    starkware_commitment_scheme.linkLibrary(commitment_scheme_merkle);

    const starkware_proof_system = b.addStaticLibrary(.{
        .name = "starkware_proof_system",
        .target = target,
        .optimize = optimize,
    });
    starkware_proof_system.linkLibCpp();
    starkware_proof_system.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/proof_system/proof_system_test.cc",
        "src/starkware/proof_system/proof_system.cc",
    } });

    const starkware_channel = b.addStaticLibrary(.{
        .name = "starkware_channel",
        .target = target,
        .optimize = optimize,
    });
    starkware_channel.linkLibCpp();
    starkware_channel.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/channel/channel_test.cc",
        "src/starkware/channel/noninteractive_channel_test.cc",
        "src/starkware/channel/noninteractive_prover_channel_test.cc",
        "src/starkware/channel/annotation_scope_test.cc",
        "src/starkware/channel/proof_of_work_test.cc",
        "src/starkware/channel/channel.cc",
        "src/starkware/channel/noninteractive_prover_channel.cc",
        "src/starkware/channel/prover_channel.cc",
        "src/starkware/channel/noninteractive_verifier_channel.cc",
        "src/starkware/channel/verifier_channel.cc",
        "src/starkware/channel/noninteractive_channel_utils.cc",
    } });

    const starkware_error_handling = b.addStaticLibrary(.{
        .name = "starkware_error_handling",
        .target = target,
        .optimize = optimize,
    });
    starkware_error_handling.linkLibCpp();
    starkware_error_handling.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/error_handling/error_handling_test.cc",
        "src/starkware/error_handling/error_handling.cc",
        "src/starkware/error_handling/error_handling.cc",
    } });

    const starkware_math = b.addStaticLibrary(.{
        .name = "starkware_math",
        .target = target,
        .optimize = optimize,
    });
    starkware_math.linkLibCpp();
    starkware_math.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/math/math_test.cc",
    } });

    const air_boundary_constraints = b.addStaticLibrary(.{
        .name = "air_boundary_constraints",
        .target = target,
        .optimize = optimize,
    });
    air_boundary_constraints.linkLibCpp();
    air_boundary_constraints.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/air/boundary_constraints/boundary_periodic_column_test.cc",
    } });

    const air_fibonacci = b.addStaticLibrary(.{
        .name = "air_fibonacci",
        .target = target,
        .optimize = optimize,
    });
    air_fibonacci.linkLibCpp();
    air_fibonacci.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/air/fibonacci/fibonacci_air_test.cc",
    } });

    const components_perm_range_check = b.addStaticLibrary(.{
        .name = "components_perm_range_check",
        .target = target,
        .optimize = optimize,
    });
    components_perm_range_check.linkLibCpp();
    components_perm_range_check.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/air/components/perm_range_check/range_check_cell_test.cc",
    } });

    const components_diluted_check = b.addStaticLibrary(.{
        .name = "components_diluted_check",
        .target = target,
        .optimize = optimize,
    });
    components_diluted_check.linkLibCpp();
    components_diluted_check.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/air/components/diluted_check/diluted_check_cell_test.cc",
        "src/starkware/air/components/diluted_check/diluted_check_test.cc",
    } });

    const components_memory = b.addStaticLibrary(.{
        .name = "components_memory",
        .target = target,
        .optimize = optimize,
    });
    components_memory.linkLibCpp();
    components_memory.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/air/components/memory/memory_cell_test.cc",
    } });

    const components_permutation = b.addStaticLibrary(.{
        .name = "components_permutation",
        .target = target,
        .optimize = optimize,
    });
    components_permutation.linkLibCpp();
    components_permutation.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/air/components/permutation/permutation_dummy_air_test.cc",
    } });

    const air_components = b.addStaticLibrary(.{
        .name = "air_components",
        .target = target,
        .optimize = optimize,
    });
    air_components.linkLibCpp();
    air_components.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/air/components/trace_generation_context_test.cc",
        "src/starkware/air/components/trace_generation_context.cc",
    } });

    air_components.linkLibrary(components_diluted_check);
    air_components.linkLibrary(components_memory);
    air_components.linkLibrary(components_perm_range_check);
    air_components.linkLibrary(components_permutation);

    const air_degree_three_example = b.addStaticLibrary(.{
        .name = "air_degree_three_example",
        .target = target,
        .optimize = optimize,
    });
    air_degree_three_example.linkLibCpp();
    air_degree_three_example.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/air/degree_three_example/degree_three_example_air_test.cc",
    } });

    const air_boundary = b.addStaticLibrary(.{
        .name = "air_boundary",
        .target = target,
        .optimize = optimize,
    });
    air_boundary.linkLibCpp();
    air_boundary.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/air/boundary/boundary_air_test.cc",
    } });

    const cpu_board = b.addStaticLibrary(.{
        .name = "cpu_board",
        .target = target,
        .optimize = optimize,
    });
    cpu_board.linkLibCpp();
    cpu_board.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/air/cpu/board/cpu_air_test.cc",
    } });

    const starkware_air = b.addStaticLibrary(.{
        .name = "starkware_air",
        .target = target,
        .optimize = optimize,
    });
    starkware_air.linkLibCpp();
    starkware_air.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/air/trace_test.cc",
        "src/starkware/air/test_utils_test.cc",
        "src/starkware/air/compile_time_optional_test.cc",
        "src/starkware/air/test_utils.cc",
    } });

    starkware_air.linkLibrary(air_boundary);
    starkware_air.linkLibrary(air_boundary_constraints);
    starkware_air.linkLibrary(cpu_board);
    starkware_air.linkLibrary(air_components);
    starkware_air.linkLibrary(air_degree_three_example);
    starkware_air.linkLibrary(air_fibonacci);

    const vm_cpp = b.addStaticLibrary(.{
        .name = "vm_cpp",
        .target = target,
        .optimize = optimize,
    });
    vm_cpp.linkLibCpp();
    vm_cpp.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/cairo/lang/vm/cpp/decoder_test.cc",
        "src/starkware/cairo/lang/vm/cpp/trace_utils_test.cc",
        "src/starkware/cairo/lang/vm/cpp/decoder.cc",
    } });

    const starkware_utils = b.addStaticLibrary(.{
        .name = "starkware_utils",
        .target = target,
        .optimize = optimize,
    });
    starkware_utils.linkLibCpp();
    starkware_utils.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/utils/stats_test.cc",
        "src/starkware/utils/profiling_test.cc",
        "src/starkware/utils/json_test.cc",
        "src/starkware/utils/bit_reversal_test.cc",
        "src/starkware/utils/maybe_owned_ptr_test.cc",
        "src/starkware/utils/to_from_string_test.cc",
        "src/starkware/utils/serialization_test.cc",
        "src/starkware/utils/task_manager_test.cc",
        "src/starkware/utils/to_from_string.cc",
        "src/starkware/utils/stats.cc",
        "src/starkware/utils/profiling.cc",
        "src/starkware/utils/json.cc",
        "src/starkware/utils/flag_validators.cc",
        "src/starkware/utils/task_manager.cc",
        "src/starkware/utils/bit_reversal.cc",
        "src/starkware/utils/input_utils.cc",
    } });

    const statement_fibonacci = b.addStaticLibrary(.{
        .name = "statement_fibonacci",
        .target = target,
        .optimize = optimize,
    });
    statement_fibonacci.linkLibCpp();
    statement_fibonacci.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/statement/fibonacci/fibonacci_statement_test.cc",
    } });

    const statement_cpu = b.addStaticLibrary(.{
        .name = "statement_cpu",
        .target = target,
        .optimize = optimize,
    });
    statement_cpu.linkLibCpp();
    statement_cpu.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/statement/cpu/cpu_air_statement.cc",
    } });

    const starkware_statement = b.addStaticLibrary(.{
        .name = "starkware_statement",
        .target = target,
        .optimize = optimize,
    });
    starkware_statement.linkLibrary(statement_cpu);
    starkware_statement.linkLibrary(statement_fibonacci);

    const starkware_stl_utils = b.addStaticLibrary(.{
        .name = "starkware_stl_utils",
        .target = target,
        .optimize = optimize,
    });
    starkware_stl_utils.linkLibCpp();
    starkware_stl_utils.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/stl_utils/containers_test.cc",
        "src/starkware/stl_utils/string_test.cc",
    } });

    const starkware_randomness = b.addStaticLibrary(.{
        .name = "starkware_randomness",
        .target = target,
        .optimize = optimize,
    });
    starkware_randomness.linkLibCpp();
    starkware_randomness.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/randomness/prng_test.cc",
        "src/starkware/randomness/hash_chain_test.cc",
        "src/starkware/randomness/prng.cc",
        "src/starkware/randomness/hash_chain.cc",
    } });

    const starkware_fft_utils = b.addStaticLibrary(.{
        .name = "starkware_fft_utils",
        .target = target,
        .optimize = optimize,
    });
    starkware_fft_utils.linkLibCpp();
    starkware_fft_utils.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/fft_utils/fft_domain_test.cc",
        "src/starkware/fft_utils/fft_bases_test.cc",
    } });

    const starkware_fri = b.addStaticLibrary(.{
        .name = "starkware_fri",
        .target = target,
        .optimize = optimize,
    });
    starkware_fri.linkLibCpp();
    starkware_fri.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/fri/fri_test.cc",
        "src/starkware/fri/fri_details_test.cc",
        "src/starkware/fri/fri_folder.cc",
        "src/starkware/fri/fri_layer_test.cc",
        "src/starkware/fri/fri_layer.cc",
        "src/starkware/fri/fri_committed_layer_test.cc",
        "src/starkware/fri/fri_committed_layer.cc",
        "src/starkware/fri/fri_layer.cc",
        "src/starkware/fri/fri_prover.cc",
        "src/starkware/fri/fri_verifier.cc",
        "src/starkware/fri/fri_details.cc",
        "src/starkware/fri/fri_folder.cc",
        "src/starkware/fri/fri_layer.cc",
        "src/starkware/fri/fri_committed_layer.cc",
    } });

    const starkware_composition_polynomial = b.addStaticLibrary(.{
        .name = "starkware_composition_polynomial",
        .target = target,
        .optimize = optimize,
    });
    starkware_composition_polynomial.linkLibCpp();
    starkware_composition_polynomial.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/starkware/composition_polynomial/periodic_column_test.cc",
        "src/starkware/composition_polynomial/multiplicative_neighbors_test.cc",
        "src/starkware/composition_polynomial/composition_polynomial_test.cc",
        "src/starkware/composition_polynomial/breaker_test.cc",
        "src/starkware/composition_polynomial/breaker.cc",
    } });

    const src_starkware = b.addStaticLibrary(.{
        .name = "src_starkware",
        .target = target,
        .optimize = optimize,
    });
    src_starkware.linkLibrary(starkware_air);
    src_starkware.linkLibrary(starkware_algebra);
    src_starkware.linkLibrary(vm_cpp);
    src_starkware.linkLibrary(starkware_channel);
    src_starkware.linkLibrary(starkware_commitment_scheme);
    src_starkware.linkLibrary(starkware_composition_polynomial);
    src_starkware.linkLibrary(starkware_crypt_tools);
    src_starkware.linkLibrary(starkware_error_handling);
    src_starkware.linkLibrary(starkware_fft_utils);
    src_starkware.linkLibrary(starkware_fri);
    src_starkware.linkLibrary(starkware_gtest);
    src_starkware.linkLibrary(starkware_main);
    src_starkware.linkLibrary(starkware_math);
    src_starkware.linkLibrary(starkware_proof_system);
    src_starkware.linkLibrary(starkware_randomness);
    src_starkware.linkLibrary(starkware_stark);
    src_starkware.linkLibrary(starkware_statement);
    src_starkware.linkLibrary(starkware_stl_utils);
    src_starkware.linkLibrary(starkware_utils);

    const XKCP_KeccakP_1600_OptimizedAVX2 = b.addStaticLibrary(.{
        .name = "XKCP_KeccakP_1600_OptimizedAVX2",
        .target = target,
        .optimize = optimize,
    });
    XKCP_KeccakP_1600_OptimizedAVX2.linkLibC();
    XKCP_KeccakP_1600_OptimizedAVX2.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/third_party/XKCP/KeccakP-1600-OptimizedAVX2/KeccakP-1600-AVX2.s",
    } });

    const XKCP_CompactFIPS202 = b.addStaticLibrary(.{
        .name = "XKCP_CompactFIPS202",
        .target = target,
        .optimize = optimize,
    });
    XKCP_CompactFIPS202.linkLibC();
    XKCP_CompactFIPS202.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/third_party/XKCP/CompactFIPS202/Keccak-readable-and-compact.c",
    } });

    const third_party_XKCP = b.addStaticLibrary(.{
        .name = "third_party_XKCP",
        .target = target,
        .optimize = optimize,
    });
    third_party_XKCP.linkLibrary(XKCP_CompactFIPS202);
    third_party_XKCP.linkLibrary(XKCP_KeccakP_1600_OptimizedAVX2);

    const third_party_jsoncpp = b.addStaticLibrary(.{
        .name = "third_party_jsoncpp",
        .target = target,
        .optimize = optimize,
    });
    third_party_jsoncpp.linkLibCpp();
    third_party_jsoncpp.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/third_party/jsoncpp/jsoncpp.cpp",
    } });

    const third_party_blake2 = b.addStaticLibrary(.{
        .name = "third_party_blake2",
        .target = target,
        .optimize = optimize,
    });
    third_party_blake2.linkLibC();
    third_party_blake2.addCSourceFiles(.{ .files = &[_][]const u8{
        "src/third_party/blake2/blake2s.c",
    } });

    const src_third_party = b.addStaticLibrary(.{
        .name = "src_third_party",
        .target = target,
        .optimize = optimize,
    });
    src_third_party.linkLibC();
    src_third_party.linkLibrary(third_party_jsoncpp);
    src_third_party.linkLibrary(third_party_blake2);
    src_third_party.linkLibrary(third_party_XKCP);

    const stone_prover_src = b.addStaticLibrary(.{
        .name = "stone_prover_src",
        .target = target,
        .optimize = optimize,
    });
    stone_prover_src.linkLibC();
    stone_prover_src.linkLibrary(src_starkware);
    stone_prover_src.linkLibrary(src_third_party);

    const zkp_stone_prover = b.addStaticLibrary(.{
        .name = "zkp_stone_prover",
        .target = target,
        .optimize = optimize,
    });
    zkp_stone_prover.linkLibrary(stone_prover_src);

    // END

    // addLibrary(b, "cpu_air_prover_main", "starkware/main/cpu/cpu_air_prover_main.cc", true, target, optimize, cpu_air_prover);
    // addLibrary(b, "cpu_air_verifier_main", "starkware/main/cpu/cpu_air_verifier_main.cc", true, target, optimize);

    const install_exe = b.addInstallArtifact(cpu_air_prover, .{});
    b.getInstallStep().dependOn(&install_exe.step);
}
