-- cleanup
DROP TYPE "T_RESULTS";
DROP TABLE "SIGNATURE";
CALL "SYS"."AFLLANG_WRAPPER_PROCEDURE_DROP"('DEVUSER', 'P_SVP');
DROP TABLE "DATA";
DROP TABLE "RESULTS";

-- procedure setup
CREATE TYPE "T_RESULTS" AS TABLE ("ID" VARCHAR(60), "IS_OUTLIER" INTEGER);

CREATE COLUMN TABLE "SIGNATURE" ("POSITION" INTEGER, "SCHEMA_NAME" NVARCHAR(256), "TYPE_NAME" NVARCHAR(256), "PARAMETER_TYPE" VARCHAR(7));
INSERT INTO "SIGNATURE" VALUES (1, 'DEVUSER', 'T_DATA', 'IN');
INSERT INTO "SIGNATURE" VALUES (2, 'DEVUSER', 'T_PARAMS', 'IN');
INSERT INTO "SIGNATURE" VALUES (3, 'DEVUSER', 'T_MODEL', 'IN');
INSERT INTO "SIGNATURE" VALUES (4, 'DEVUSER', 'T_RESULTS', 'OUT');

CALL "SYS"."AFLLANG_WRAPPER_PROCEDURE_CREATE"('AFLPAL', 'SVMPREDICT', 'DEVUSER', 'P_SVP', "SIGNATURE");

-- data setup
CREATE COLUMN TABLE "DATA" LIKE "T_DATA";
CREATE COLUMN TABLE "RESULTS" LIKE "T_RESULTS";

-- runtime
DROP TABLE "#PARAMS";
CREATE LOCAL TEMPORARY COLUMN TABLE "#PARAMS" LIKE "T_PARAMS";
INSERT INTO "#PARAMS" VALUES ('THREAD_NUMBER', 4, null, null);
INSERT INTO "#PARAMS" VALUES ('VERBOSE_OUTPUT', 0, null, null); -- 0: no, 1: yes (default:0)

TRUNCATE TABLE "DATA";
INSERT INTO DATA VALUES (151,5.7,2.8,4.1,1.4); -- normal
INSERT INTO DATA VALUES (152,1.0,2.0,2.5,0.75); -- outlier
TRUNCATE TABLE "RESULTS";

CALL "P_SVP" ("DATA", "#PARAMS", "MODEL", "RESULTS") WITH OVERVIEW;

SELECT * FROM "RESULTS";
