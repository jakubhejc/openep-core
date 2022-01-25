classdef getMeshTest < matlab.unittest.TestCase

    properties(TestParameter)
        type = {'trirep'; 'triangulation'; 'struct'};
        limitToTriangulation = {{true, 5432, 10296}; {false, 9279, 10296}};
    end

    properties
        userdata;
        triRep_surface;
        triangulation_surface;
        struct_surface;
    end

    methods(TestClassSetup)
        function loadData(testCase)

            testCase.userdata = load('openep_dataset_1.mat').userdata;

            vertices = testCase.userdata.surface.triRep.X;
            faces = testCase.userdata.surface.triRep.Triangulation;
            
            testCase.triRep_surface = TriRep(faces, vertices(:,1), vertices(:,2), vertices(:,3));
            testCase.triangulation_surface = triangulation(faces, vertices);
            testCase.struct_surface.X = vertices;
            testCase.struct_surface.Triangulation = faces;

        end
    end

    methods(Test, ParameterCombination = 'pairwise')

        function triRepInput(testCase, type, limitToTriangulation)

            testCase.userdata.surface.triRep = testCase.triRep_surface;
            [limit, expected_num_vertices, expected_num_faces] = limitToTriangulation{:};

            tr = getMesh( ...
                testCase.userdata, ...
                'type', type, ...
                'limitToTriangulation', limit);

            switch type
                case 'triangulation'
                    testCase.verifyEqual(length(tr.Points), expected_num_vertices);
                    testCase.verifyEqual(length(tr.ConnectivityList), expected_num_faces);
                otherwise
                    testCase.verifyEqual(length(tr.X), expected_num_vertices);
                    testCase.verifyEqual(length(tr.Triangulation), expected_num_faces);
            end

        end

    end

end