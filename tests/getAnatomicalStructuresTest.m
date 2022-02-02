classdef getAnatomicalStructuresTest < matlab.unittest.TestCase

    properties
        dataset_2
        FF
        l
        a
        tr
    end

    methods(Test)
        function verifyLengths(testCase)
            [FF, l, a, tr] = getAnatomicalStructures( testCase.dataset_2, 'plot', false); %#ok<ASGLU,PROP>
            testCase.verifyEqual(round(l, 3), round(testCase.l, 3)); %#ok<PROP>
        end
        function verifyAreas(testCase)
            [FF, l, a, tr] = getAnatomicalStructures( testCase.dataset_2, 'plot', false); %#ok<ASGLU,PROP>
            testCase.verifyEqual(round(a, 3), round(testCase.a, 3)); %#ok<PROP>
        end
        function verifyPerimeters(testCase)
            [FF, l, a, tr] = getAnatomicalStructures( testCase.dataset_2, 'plot', false); %#ok<ASGLU,PROP>
            for i = 1:numel(FF)
                testCase.verifyEqual(FF{i}, testCase.FF{i});
            end
        end
    end

    methods(TestClassSetup)
        function loadData(testCase)
            testCase.dataset_2 = load('openep_dataset_2.mat').userdata;
            testCase.l = [67.994        97.084       48.467       120.374       66.102        82.970       63.446];
            testCase.a = [331.549	    634.814	     154.774	    949.773	    260.175	    508.782	    282.030];

            testCase.FF{1} = [448 14192;14192 14164;14164 14168;14168 14225;14225 14182;14182 14179;14179 14210;14210 14162;14162 14211;14211 14193;14193 14194;14194 14169;14169 14144;14144 14170;14170 14171;14171 14148;14148 6205;6205 14212;14212 10474;10474 14195;14195 14213;14213 14214;14214 14215;14215 14196;14196 14181;14181 14180;14180 14173;14173 14224;14224 14216;14216 14198;14198 14217;14217 14199;14199 14157;14157 14218;14218 14200;14200 14204;14204 14174;14174 14147;14147 14145;14145 14219;14219 14220;14220 14203;14203 14176;14176 14205;14205 14150;14150 14166;14166 14178;14178 14207;14207 14221;14221 14206;14206 14167;14167 14183;14183 14197;14197 14172;14172 14151;14151 14159;14159 14184;14184 14160;14160 14222;14222 14185;14185 14208;14208 14154;14154 14186;14186 14149;14149 14187;14187 14153;14153 14188;14188 14158;14158 14155;14155 14190;14190 14177;14177 14163;14163 14152;14152 14146;14146 14209;14209 14161;14161 8259;8259 14165;14165 14175;14175 14202;14202 14201;14201 14189;14189 14191;14191 14223;14223 14156;14156 448];
            testCase.FF{2} = [897 13824;13824 13821;13821 13866;13866 13839;13839 13865;13865 13833;13833 13864;13864 13809;13809 13861;13861 13892;13892 13891;13891 13838;13838 13834;13834 13827;13827 13837;13837 13843;13843 13860;13860 13889;13889 12099;12099 13918;13918 13936;13936 13830;13830 13888;13888 13887;13887 13917;13917 13935;13935 13886;13886 13916;13916 13881;13881 13915;13915 13914;13914 13822;13822 13835;13835 13859;13859 13832;13832 13857;13857 13831;13831 13841;13841 13807;13807 13811;13811 13813;13813 13828;13828 13815;13815 13856;13856 13885;13885 13913;13913 13855;13855 13874;13874 13853;13853 13884;13884 13908;13908 13810;13810 13826;13826 13836;13836 13818;13818 13814;13814 13825;13825 13851;13851 13849;13849 13882;13882 13912;13912 13880;13880 13879;13879 13911;13911 13934;13934 13877;13877 13876;13876 13910;13910 13909;13909 13933;13933 13932;13932 13941;13941 13904;13904 13875;13875 13931;13931 13940;13940 13939;13939 13921;13921 13930;13930 13922;13922 13944;13944 13929;13929 13938;13938 13943;13943 13937;13937 13942;13942 13816;13816 13848;13848 13872;13872 13817;13817 13847;13847 13829;13829 13871;13871 13907;13907 13819;13819 13906;13906 13928;13928 13850;13850 13905;13905 13878;13878 13808;13808 13806;13806 13846;13846 13845;13845 13862;13862 13903;13903 13927;13927 13858;13858 13902;13902 13873;13873 13820;13820 13844;13844 13870;13870 13854;13854 13842;13842 13869;13869 13901;13901 13900;13900 13926;13926 13899;13899 13812;13812 2448;2448 13805;13805 13890;13890 13840;13840 13868;13868 13823;13823 13898;13898 13925;13925 13924;13924 13897;13897 13896;13896 13895;13895 13923;13923 13852;13852 13863;13863 13920;13920 13883;13883 13919;13919 13867;13867 13894;13894 13893;13893 897];
            testCase.FF{3} = [917 14364;14364 14373;14373 14365;14365 14381;14381 14374;14374 14375;14375 14349;14349 14376;14376 14367;14367 14346;14346 14347;14347 14333;14333 14368;14368 14345;14345 14324;14324 14370;14370 14332;14332 14322;14322 14350;14350 14334;14334 3619;3619 14351;14351 14335;14335 14352;14352 14355;14355 14356;14356 14323;14323 14336;14336 14327;14327 14320;14320 14340;14340 14326;14326 14321;14321 14358;14358 14328;14328 14337;14337 14329;14329 14377;14377 14366;14366 14369;14369 14360;14360 14371;14371 14359;14359 14382;14382 14378;14378 14383;14383 14379;14379 14353;14353 14341;14341 14380;14380 14372;14372 14361;14361 14362;14362 14338;14338 14339;14339 14325;14325 14319;14319 14331;14331 14330;14330 10266;10266 9501;9501 14344;14344 14357;14357 14342;14342 14348;14348 14363;14363 14354;14354 14343;14343 917];
            testCase.FF{4} = [1146 13757;13757 13756;13756 13755;13755 13688;13688 13689;13689 13700;13700 13754;13754 13660;13660 13753;13753 13677;13677 13717;13717 13752;13752 5711;5711 4408;4408 13797;13797 13804;13804 13779;13779 13796;13796 13751;13751 13785;13785 13795;13795 13803;13803 13802;13802 13661;13661 13662;13662 13683;13683 13750;13750 13783;13783 13664;13664 13650;13650 13686;13686 13675;13675 13715;13715 13701;13701 13749;13749 13670;13670 13747;13747 13784;13784 13746;13746 13745;13745 13741;13741 13744;13744 13694;13694 13782;13782 13743;13743 13781;13781 13684;13684 13707;13707 13705;13705 13714;13714 13712;13712 13742;13742 13679;13679 13780;13780 13794;13794 13793;13793 13652;13652 13648;13648 13740;13740 13716;13716 13778;13778 13739;13739 13777;13777 13748;13748 13657;13657 13663;13663 13682;13682 13680;13680 13711;13711 13685;13685 13647;13647 13738;13738 13678;13678 13710;13710 13737;13737 13709;13709 13671;13671 13708;13708 13736;13736 13676;13676 13697;13697 13735;13735 13734;13734 13775;13775 13666;13666 13706;13706 13655;13655 13703;13703 13674;13674 13733;13733 13649;13649 13672;13672 13732;13732 13731;13731 13730;13730 13774;13774 13762;13762 13792;13792 13651;13651 13668;13668 13699;13699 13729;13729 13764;13764 13773;13773 13791;13791 13654;13654 13772;13772 13771;13771 13693;13693 13702;13702 13691;13691 13696;13696 13770;13770 13728;13728 13727;13727 13769;13769 13667;13667 13768;13768 13726;13726 13725;13725 13790;13790 13801;13801 13767;13767 13789;13789 13665;13665 13698;13698 13695;13695 13724;13724 13656;13656 13723;13723 13713;13713 13766;13766 13692;13692 13690;13690 13681;13681 13722;13722 13765;13765 13788;13788 13776;13776 13721;13721 13787;13787 13800;13800 13669;13669 13720;13720 13704;13704 13763;13763 13761;13761 13673;13673 13799;13799 13718;13718 13687;13687 13760;13760 13786;13786 13658;13658 13759;13759 13719;13719 13758;13758 13659;13659 13798;13798 13646;13646 13653;13653 1146];
            testCase.FF{5} = [3550 14100;14100 14120;14120 14077;14077 14119;14119 14135;14135 14118;14118 14117;14117 14075;14075 14047;14047 11471;11471 14091;14091 4108;4108 14116;14116 14115;14115 14042;14042 14046;14046 14039;14039 14072;14072 14067;14067 14048;14048 14069;14069 14062;14062 14065;14065 14099;14099 14114;14114 14063;14063 14113;14113 14134;14134 14097;14097 14112;14112 14111;14111 14133;14133 14110;14110 14132;14132 14140;14140 14131;14131 14064;14064 14061;14061 14071;14071 14087;14087 14109;14109 14108;14108 14090;14090 14051;14051 14083;14083 14107;14107 14130;14130 14086;14086 14129;14129 14089;14089 14128;14128 14040;14040 14059;14059 14095;14095 14096;14096 14094;14094 14106;14106 14057;14057 9282;9282 14074;14074 14070;14070 14127;14127 14044;14044 14085;14085 14139;14139 14073;14073 14105;14105 14104;14104 14126;14126 14058;14058 14125;14125 14124;14124 14138;14138 14142;14142 14143;14143 14054;14054 14045;14045 14093;14093 14041;14041 14080;14080 14092;14092 14088;14088 14050;14050 14056;14056 14103;14103 14084;14084 14066;14066 14053;14053 14102;14102 14123;14123 14137;14137 14122;14122 14098;14098 14076;14076 14121;14121 14078;14078 14068;14068 14055;14055 14136;14136 14141;14141 14043;14043 14052;14052 14082;14082 14081;14081 14060;14060 14049;14049 14079;14079 14101;14101 4429;4429 3550];
            testCase.FF{6} = [4530 14288;14288 14247;14247 14308;14308 14289;14289 14279;14279 14245;14245 14246;14246 14227;14227 14290;14290 14242;14242 14280;14280 14250;14250 14252;14252 14309;14309 14291;14291 14310;14310 14292;14292 14230;14230 14253;14253 14281;14281 14255;14255 14234;14234 14238;14238 14311;14311 14312;14312 14293;14293 14294;14294 10680;10680 14295;14295 14254;14254 14282;14282 14317;14317 14273;14273 4973;4973 14313;14313 14249;14249 14236;14236 14314;14314 14296;14296 14297;14297 14240;14240 14257;14257 14259;14259 14298;14298 14299;14299 14265;14265 14300;14300 14275;14275 14260;14260 14229;14229 14283;14283 14284;14284 14261;14261 14315;14315 14301;14301 14263;14263 14302;14302 14256;14256 14264;14264 14228;14228 14303;14303 14276;14276 14258;14258 14266;14266 14267;14267 14272;14272 14270;14270 14285;14285 14268;14268 14248;14248 14271;14271 14239;14239 14226;14226 14251;14251 14235;14235 14243;14243 14316;14316 14304;14304 14286;14286 14305;14305 14278;14278 14306;14306 14287;14287 14233;14233 14274;14274 14269;14269 14232;14232 14277;14277 14241;14241 14237;14237 14244;14244 14231;14231 11124;11124 14307;14307 14318;14318 14262;14262 4530];
            testCase.FF{7} = [11840 13968;13968 13969;13969 13946;13946 13992;13992 13949;13949 13954;13954 13963;13963 13962;13962 13990;13990 13960;13960 13988;13988 13951;13951 13959;13959 13945;13945 13982;13982 13961;13961 13991;13991 13950;13950 13986;13986 13989;13989 13985;13985 14007;14007 13987;13987 14023;14023 14022;14022 14033;14033 14006;14006 14021;14021 14002;14002 14020;14020 13984;13984 13998;13998 13956;13956 13981;13981 14019;14019 14018;14018 13995;13995 14017;14017 14016;14016 14015;14015 14005;14005 14014;14014 14008;14008 14032;14032 13955;13955 13947;13947 13973;13973 13958;13958 13957;13957 13974;13974 13980;13980 14004;14004 14013;14013 13964;13964 14001;14001 13978;13978 14000;14000 13979;13979 13972;13972 14031;14031 13997;13997 13948;13948 13976;13976 13953;13953 13983;13983 14012;14012 14030;14030 13999;13999 14029;14029 14036;14036 14003;14003 13977;13977 13993;13993 14035;14035 14037;14037 14038;14038 13970;13970 13966;13966 14028;14028 14027;14027 13952;13952 13975;13975 13971;13971 13967;13967 13996;13996 14011;14011 14026;14026 14010;14010 14025;14025 14034;14034 13965;13965 13994;13994 14009;14009 14024;14024 11840];
        end
    end
end