const std = @import("std");

fn addLibrary(b: *std.build.Builder, name: []const u8, path: []const u8, flag_cc: bool, target: std.zig.CrossTarget, optimize: std.builtin.OptimizeMode, cpu_air_prover: *std.build.Step.Compile) void {
    const library = b.addStaticLibrary(.{
        .name = name,
        .target = target,
        .optimize = optimize,
    });
    if (flag_cc) {
        library.linkLibCpp();
    } else {
        library.linkLibC();
    }

    if (!std.mem.eql(u8, path, ""))
        library.addCSourceFile(.{
            .file = .{ .path = path },
            .flags = &.{"-I./"},
        });

    cpu_air_prover.linkLibrary(library);
}

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    var cpu_air_prover = b.addExecutable(.{ .name = "cpu_air_prover", .target = target, .optimize = optimize });
    cpu_air_prover.addCSourceFile(.{
        .file = .{ .path = "src/starkware/main/cpu/cpu_air_prover_main.cc" },
        .flags = &.{"-I./"},
    });
    cpu_air_prover.linkLibCpp();

    // -----------BEGIN ZONE TO REPLACE-----------

    addLibrary(b, "blake2s", "src/third_party/blake2/blake2s.c", false, target, optimize, cpu_air_prover);

    addLibrary(b, "Keccak-readable-and-compact", "src/third_party/XKCP/CompactFIPS202/Keccak-readable-and-compact.c", false, target, optimize, cpu_air_prover);

    addLibrary(b, "composition_polynomial_test", "src/starkware/composition_polynomial/composition_polynomial_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "periodic_column_test", "src/starkware/composition_polynomial/periodic_column_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "breaker", "src/starkware/composition_polynomial/breaker.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "breaker_test", "src/starkware/composition_polynomial/breaker_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "multiplicative_neighbors_test", "src/starkware/composition_polynomial/multiplicative_neighbors_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "fri_committed_layer", "src/starkware/fri/fri_committed_layer.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "fri_verifier", "src/starkware/fri/fri_verifier.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "fri_layer_test", "src/starkware/fri/fri_layer_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "fri_prover", "src/starkware/fri/fri_prover.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "fri_details_test", "src/starkware/fri/fri_details_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "fri_details", "src/starkware/fri/fri_details.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "fri_folder", "src/starkware/fri/fri_folder.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "fri_committed_layer_test", "src/starkware/fri/fri_committed_layer_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "fri_test", "src/starkware/fri/fri_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "fri_layer", "src/starkware/fri/fri_layer.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "fft_domain_test", "src/starkware/fft_utils/fft_domain_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "fft_bases_test", "src/starkware/fft_utils/fft_bases_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "hash_chain", "src/starkware/randomness/hash_chain.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "hash_chain_test", "src/starkware/randomness/hash_chain_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "prng_test", "src/starkware/randomness/prng_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "prng", "src/starkware/randomness/prng.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "string_test", "src/starkware/stl_utils/string_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "containers_test", "src/starkware/stl_utils/containers_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "cpu_air_statement", "src/starkware/statement/cpu/cpu_air_statement.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "fibonacci_statement_test", "src/starkware/statement/fibonacci/fibonacci_statement_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "bit_reversal_test", "src/starkware/utils/bit_reversal_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "to_from_string", "src/starkware/utils/to_from_string.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "stats_test", "src/starkware/utils/stats_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "profiling", "src/starkware/utils/profiling.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "profiling_test", "src/starkware/utils/profiling_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "serialization_test", "src/starkware/utils/serialization_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "json", "src/starkware/utils/json.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "maybe_owned_ptr_test", "src/starkware/utils/maybe_owned_ptr_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "json_test", "src/starkware/utils/json_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "input_utils", "src/starkware/utils/input_utils.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "stats", "src/starkware/utils/stats.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "task_manager", "src/starkware/utils/task_manager.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "flag_validators", "src/starkware/utils/flag_validators.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "to_from_string_test", "src/starkware/utils/to_from_string_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "task_manager_test", "src/starkware/utils/task_manager_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "bit_reversal", "src/starkware/utils/bit_reversal.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "decoder", "src/starkware/cairo/lang/vm/cpp/decoder.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "decoder_test", "src/starkware/cairo/lang/vm/cpp/decoder_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "trace_utils_test", "src/starkware/cairo/lang/vm/cpp/trace_utils_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "test_utils_test", "src/starkware/air/test_utils_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "compile_time_optional_test", "src/starkware/air/compile_time_optional_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "test_utils", "src/starkware/air/test_utils.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "trace_test", "src/starkware/air/trace_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "cpu_air_test", "src/starkware/air/cpu/board/cpu_air_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "boundary_air_test", "src/starkware/air/boundary/boundary_air_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "degree_three_example_air_test", "src/starkware/air/degree_three_example/degree_three_example_air_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "trace_generation_context", "src/starkware/air/components/trace_generation_context.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "trace_generation_context_test", "src/starkware/air/components/trace_generation_context_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "permutation_dummy_air_test", "src/starkware/air/components/permutation/permutation_dummy_air_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "memory_cell_test", "src/starkware/air/components/memory/memory_cell_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "diluted_check_test", "src/starkware/air/components/diluted_check/diluted_check_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "diluted_check_cell_test", "src/starkware/air/components/diluted_check/diluted_check_cell_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "range_check_cell_test", "src/starkware/air/components/perm_range_check/range_check_cell_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "fibonacci_air_test", "src/starkware/air/fibonacci/fibonacci_air_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "boundary_periodic_column_test", "src/starkware/air/boundary_constraints/boundary_periodic_column_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "math_test", "src/starkware/math/math_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "error_handling", "src/starkware/error_handling/error_handling.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "error_handling_test", "src/starkware/error_handling/error_handling_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "prover_channel", "src/starkware/channel/prover_channel.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "noninteractive_verifier_channel", "src/starkware/channel/noninteractive_verifier_channel.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "noninteractive_prover_channel_test", "src/starkware/channel/noninteractive_prover_channel_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "channel", "src/starkware/channel/channel.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "noninteractive_channel_utils", "src/starkware/channel/noninteractive_channel_utils.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "verifier_channel", "src/starkware/channel/verifier_channel.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "channel_test", "src/starkware/channel/channel_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "proof_of_work_test", "src/starkware/channel/proof_of_work_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "noninteractive_channel_test", "src/starkware/channel/noninteractive_channel_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "annotation_scope_test", "src/starkware/channel/annotation_scope_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "noninteractive_prover_channel", "src/starkware/channel/noninteractive_prover_channel.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "proof_system", "src/starkware/proof_system/proof_system.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "proof_system_test", "src/starkware/proof_system/proof_system_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "parallel_table_prover_test", "src/starkware/commitment_scheme/parallel_table_prover_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "commitment_scheme_test", "src/starkware/commitment_scheme/commitment_scheme_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "table_prover_impl_test", "src/starkware/commitment_scheme/table_prover_impl_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "parallel_table_prover", "src/starkware/commitment_scheme/parallel_table_prover.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "packer_hasher", "src/starkware/commitment_scheme/packer_hasher.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "table_verifier_impl", "src/starkware/commitment_scheme/table_verifier_impl.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "table_verifier_impl_test", "src/starkware/commitment_scheme/table_verifier_impl_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "caching_commitment_scheme", "src/starkware/commitment_scheme/caching_commitment_scheme.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "packaging_commitment_scheme", "src/starkware/commitment_scheme/packaging_commitment_scheme.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "caching_commitment_scheme_test", "src/starkware/commitment_scheme/caching_commitment_scheme_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "packaging_commitment_scheme_test", "src/starkware/commitment_scheme/packaging_commitment_scheme_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "table_prover_impl", "src/starkware/commitment_scheme/table_prover_impl.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "table_impl_details", "src/starkware/commitment_scheme/table_impl_details.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "merkle_test", "src/starkware/commitment_scheme/merkle/merkle_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "merkle_commitment_scheme", "src/starkware/commitment_scheme/merkle/merkle_commitment_scheme.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "merkle", "src/starkware/commitment_scheme/merkle/merkle.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "gtest_main", "src/starkware/gtest/gtest_main.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "blake2s_test", "src/starkware/crypt_tools/blake2s_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "test_utils", "src/starkware/crypt_tools/test_utils.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "masked_hash_test", "src/starkware/crypt_tools/masked_hash_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "pedersen_test", "src/starkware/crypt_tools/pedersen_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "keccak_256_test", "src/starkware/crypt_tools/keccak_256_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "utils_test", "src/starkware/crypt_tools/utils_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "pedersen_hash_context", "src/starkware/crypt_tools/hash_context/pedersen_hash_context.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "verifier_main_helper_impl", "src/starkware/main/verifier_main_helper_impl.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "prover_main_helper", "src/starkware/main/prover_main_helper.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "prover_main_helper_impl", "src/starkware/main/prover_main_helper_impl.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "verifier_main_helper", "src/starkware/main/verifier_main_helper.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "cpu_air_prover_main", "src/starkware/main/cpu/cpu_air_prover_main.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "cpu_air_verifier_main", "src/starkware/main/cpu/cpu_air_verifier_main.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "composition_oracle", "src/starkware/stark/composition_oracle.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "oods", "src/starkware/stark/oods.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "utils", "src/starkware/stark/utils.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "stark", "src/starkware/stark/stark.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "committed_trace_test", "src/starkware/stark/committed_trace_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "stark_test", "src/starkware/stark/stark_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "oods_test", "src/starkware/stark/oods_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "stark_params_test", "src/starkware/stark/stark_params_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "composition_oracle_test", "src/starkware/stark/composition_oracle_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "committed_trace", "src/starkware/stark/committed_trace.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "polynomials_test", "src/starkware/algebra/polynomials_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "field_to_int_test", "src/starkware/algebra/field_to_int_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "field_element_base_test", "src/starkware/algebra/field_element_base_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "field_operations_test", "src/starkware/algebra/field_operations_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "big_int_test", "src/starkware/algebra/big_int_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "field_operations_axioms_test", "src/starkware/algebra/field_operations_axioms_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "field_test", "src/starkware/algebra/polymorphic/field_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "field_element_span_test", "src/starkware/algebra/polymorphic/field_element_span_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "field_element_test", "src/starkware/algebra/polymorphic/field_element_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "field_element_vector_test", "src/starkware/algebra/polymorphic/field_element_vector_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "field_element_vector", "src/starkware/algebra/polymorphic/field_element_vector.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "field_element_span", "src/starkware/algebra/polymorphic/field_element_span.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "field_element", "src/starkware/algebra/polymorphic/field_element.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "field", "src/starkware/algebra/polymorphic/field.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "elliptic_curve_test", "src/starkware/algebra/elliptic_curve/elliptic_curve_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "multiplicative_group_test", "src/starkware/algebra/domains/multiplicative_group_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "list_of_cosets", "src/starkware/algebra/domains/list_of_cosets.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "list_of_cosets_test", "src/starkware/algebra/domains/list_of_cosets_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "multiplicative_group", "src/starkware/algebra/domains/multiplicative_group.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "name_to_field", "src/starkware/algebra/utils/name_to_field.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "name_to_field_test", "src/starkware/algebra/utils/name_to_field_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "invoke_template_version_test", "src/starkware/algebra/utils/invoke_template_version_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "fft", "src/starkware/algebra/fft/fft.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "fft_test", "src/starkware/algebra/fft/fft_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "fraction_field_element_test", "src/starkware/algebra/fields/fraction_field_element_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "prime_field_element", "src/starkware/algebra/fields/prime_field_element.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "field_operations_helper_test", "src/starkware/algebra/fields/field_operations_helper_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "test_field_element", "src/starkware/algebra/fields/test_field_element.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "prime_field_element_test", "src/starkware/algebra/fields/prime_field_element_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "extension_field_element_test", "src/starkware/algebra/fields/extension_field_element_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "long_field_element", "src/starkware/algebra/fields/long_field_element.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "long_field_element_test", "src/starkware/algebra/fields/long_field_element_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "test_field_element_test", "src/starkware/algebra/fields/test_field_element_test.cc", true, target, optimize, cpu_air_prover);

    addLibrary(b, "cached_lde_manager_test", "src/starkware/algebra/lde/cached_lde_manager_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "cached_lde_manager", "src/starkware/algebra/lde/cached_lde_manager.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "lde_test", "src/starkware/algebra/lde/lde_test.cc", true, target, optimize, cpu_air_prover);
    addLibrary(b, "lde", "src/starkware/algebra/lde/lde.cc", true, target, optimize, cpu_air_prover);

    // -----------END ZONE TO REPLACE-----------

    // addLibrary(b, "cpu_air_prover_main", "starkware/main/cpu/cpu_air_prover_main.cc", true, target, optimize, cpu_air_prover);
    // addLibrary(b, "cpu_air_verifier_main", "starkware/main/cpu/cpu_air_verifier_main.cc", true, target, optimize);

    const install_exe = b.addInstallArtifact(cpu_air_prover, .{});
    b.getInstallStep().dependOn(&install_exe.step);
}
