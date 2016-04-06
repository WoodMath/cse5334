
v_class = [1,1,1,1,1,1,1,2,2,2,2,2,2,2,3,3,3,3,3,3,3];
i_fold = 3;
i_count_classes = 3;
i_count_samples = 7;

[cell_subsets_numerical, cell_subsets_boolean] = fnSubsetIndices(v_class, i_fold, i_count_classes, i_count_samples );


v_class = [1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3];
i_fold = 3;
i_count_classes = 3;
i_count_samples = 8;

[cell_subsets_numerical, cell_subsets_boolean] = fnSubsetIndices(v_class, i_fold, i_count_classes, i_count_samples );
