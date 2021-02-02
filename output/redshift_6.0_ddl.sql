/*********************************************************************************
# COPYRIGHT 2018-08 OBSERVATIONAL HEALTH DATA SCIENCES AND INFORMATICS
#
#
# LICENSED UNDER THE APACHE LICENSE, VERSION 2.0 (THE "LICENSE");
# YOU MAY NOT USE THIS FILE EXCEPT IN COMPLIANCE WITH THE LICENSE.
# YOU MAY OBTAIN A COPY OF THE LICENSE AT
#
#     HTTP://WWW.APACHE.ORG/LICENSES/LICENSE-2.0
#
# UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING, SOFTWARE
# DISTRIBUTED UNDER THE LICENSE IS DISTRIBUTED ON AN "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
# SEE THE LICENSE FOR THE SPECIFIC LANGUAGE GOVERNING PERMISSIONS AND
# LIMITATIONS UNDER THE LICENSE.
********************************************************************************/

/************************

 ####### #     # ####### ######      #####  ######  #     #            #####        ###
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #     #      #   #
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #           #     #
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######      #     #
 #     # #     # #     # #          #       #     # #     #    #    # #     # ### #     #
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ###  #   #
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ###   ###

REDSHIFT SCRIPT TO CREATE OMOP COMMON DATA MODEL VERSION 6.0

LAST REVISED: 27-AUG-2018

AUTHORS:  PATRICK RYAN, CHRISTIAN REICH, CLAIR BLACKETER


*************************/


/************************

STANDARDIZED VOCABULARY

************************/


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.CONCEPT  (
  CONCEPT_ID			INTEGER			NOT NULL ,
  CONCEPT_NAME			VARCHAR(255)	NOT NULL ,
  DOMAIN_ID				VARCHAR(20)		NOT NULL ,
  VOCABULARY_ID			VARCHAR(20)		NOT NULL ,
  CONCEPT_CLASS_ID		VARCHAR(20)		NOT NULL ,
  STANDARD_CONCEPT		VARCHAR(1)		NULL ,
  CONCEPT_CODE			VARCHAR(50)		NOT NULL ,
  VALID_START_DATE		DATE			NOT NULL ,
  VALID_END_DATE		DATE			NOT NULL ,
  INVALID_REASON		VARCHAR(1)		NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.VOCABULARY  (
  VOCABULARY_ID			    VARCHAR(20)		NOT NULL,
  VOCABULARY_NAME		    VARCHAR(255)	NOT NULL,
  VOCABULARY_REFERENCE		VARCHAR(255)	NOT NULL,
  VOCABULARY_VERSION	 	VARCHAR(255)	NULL,
  VOCABULARY_CONCEPT_ID		INTEGER			NOT NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.DOMAIN  (
  DOMAIN_ID			    VARCHAR(20)		NOT NULL,
  DOMAIN_NAME		    VARCHAR(255)	NOT NULL,
  DOMAIN_CONCEPT_ID		INTEGER			NOT NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.CONCEPT_CLASS  (
  CONCEPT_CLASS_ID			    VARCHAR(20)		NOT NULL,
  CONCEPT_CLASS_NAME		    VARCHAR(255)	NOT NULL,
  CONCEPT_CLASS_CONCEPT_ID		INTEGER			NOT NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.CONCEPT_RELATIONSHIP  (
  CONCEPT_ID_1			INTEGER			NOT NULL,
  CONCEPT_ID_2			INTEGER			NOT NULL,
  RELATIONSHIP_ID		VARCHAR(20)		NOT NULL,
  VALID_START_DATE		DATE			NOT NULL,
  VALID_END_DATE		DATE			NOT NULL,
  INVALID_REASON		VARCHAR(1)		NULL
  )
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.RELATIONSHIP  (
  RELATIONSHIP_ID			VARCHAR(20)		NOT NULL,
  RELATIONSHIP_NAME			VARCHAR(255)	NOT NULL,
  IS_HIERARCHICAL			VARCHAR(1)		NOT NULL,
  DEFINES_ANCESTRY			VARCHAR(1)		NOT NULL,
  REVERSE_RELATIONSHIP_ID	VARCHAR(20)		NOT NULL,
  RELATIONSHIP_CONCEPT_ID	INTEGER			NOT NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.CONCEPT_SYNONYM  (
  CONCEPT_ID			    INTEGER			NOT NULL,
  CONCEPT_SYNONYM_NAME		VARCHAR(1000)	NOT NULL,
  LANGUAGE_CONCEPT_ID	  	INTEGER			NOT NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.CONCEPT_ANCESTOR  (
  ANCESTOR_CONCEPT_ID		    INTEGER		NOT NULL,
  DESCENDANT_CONCEPT_ID		  	INTEGER		NOT NULL,
  MIN_LEVELS_OF_SEPARATION		INTEGER		NOT NULL,
  MAX_LEVELS_OF_SEPARATION		INTEGER		NOT NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.SOURCE_TO_CONCEPT_MAP  (
  SOURCE_CODE				VARCHAR(50)		NOT NULL,
  SOURCE_CONCEPT_ID			INTEGER			NOT NULL,
  SOURCE_VOCABULARY_ID		VARCHAR(20)		NOT NULL,
  SOURCE_CODE_DESCRIPTION	VARCHAR(255)	NULL,
  TARGET_CONCEPT_ID			INTEGER			NOT NULL,
  TARGET_VOCABULARY_ID		VARCHAR(20)		NOT NULL,
  VALID_START_DATE			DATE			NOT NULL,
  VALID_END_DATE			DATE			NOT NULL,
  INVALID_REASON			VARCHAR(1)		NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.DRUG_STRENGTH  (
  DRUG_CONCEPT_ID				INTEGER		NOT NULL,
  INGREDIENT_CONCEPT_ID			INTEGER		NOT NULL,
  AMOUNT_VALUE					FLOAT		NULL,
  AMOUNT_UNIT_CONCEPT_ID		INTEGER		NULL,
  NUMERATOR_VALUE				FLOAT		NULL,
  NUMERATOR_UNIT_CONCEPT_ID		INTEGER		NULL,
  DENOMINATOR_VALUE				FLOAT		NULL,
  DENOMINATOR_UNIT_CONCEPT_ID	INTEGER		NULL,
  BOX_SIZE						INTEGER		NULL,
  VALID_START_DATE				DATE		NOT NULL,
  VALID_END_DATE				DATE		NOT NULL,
  INVALID_REASON				VARCHAR(1)  NULL
)
DISTSTYLE ALL;


/**************************

STANDARDIZED META-DATA

***************************/


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.CDM_SOURCE  (
  CDM_SOURCE_NAME					VARCHAR(255)	NOT NULL ,
  CDM_SOURCE_ABBREVIATION			VARCHAR(25)		NULL ,
  CDM_HOLDER						VARCHAR(255)	NULL ,
  SOURCE_DESCRIPTION				VARCHAR(MAX)	NULL ,
  SOURCE_DOCUMENTATION_REFERENCE	VARCHAR(255)	NULL ,
  CDM_ETL_REFERENCE					VARCHAR(255)	NULL ,
  SOURCE_RELEASE_DATE				DATE			NULL ,
  CDM_RELEASE_DATE					DATE			NULL ,
  CDM_VERSION						VARCHAR(10)		NULL ,
  VOCABULARY_VERSION				VARCHAR(20)		NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.METADATA  (
  METADATA_CONCEPT_ID       INTEGER       NOT NULL ,
  METADATA_TYPE_CONCEPT_ID  INTEGER       NOT NULL ,
  NAME                      VARCHAR(250)  NOT NULL ,
  VALUE_AS_STRING           VARCHAR(MAX)  NULL ,
  VALUE_AS_CONCEPT_ID       INTEGER       NULL ,
  METADATA_DATE             DATE          NULL ,
  METADATA_DATETIME         TIMESTAMP     NULL
)
DISTSTYLE ALL;

INSERT INTO cdm_synthea_v53.METADATA (METADATA_CONCEPT_ID, METADATA_TYPE_CONCEPT_ID, NAME, VALUE_AS_STRING, VALUE_AS_CONCEPT_ID, METADATA_DATE, METADATA_DATETIME)
VALUES (0, 0, 'CDM VERSION', '6.0', 0, NULL, NULL)
;


/************************

STANDARDIZED CLINICAL DATA

************************/


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.PERSON  (
  PERSON_ID						BIGINT	  		NOT NULL ,
  GENDER_CONCEPT_ID				INTEGER	  		NOT NULL ,
  YEAR_OF_BIRTH					INTEGER	  		NOT NULL ,
  MONTH_OF_BIRTH				INTEGER	  		NULL,
  DAY_OF_BIRTH					INTEGER	  		NULL,
  BIRTH_DATETIME				TIMESTAMP	  	NULL,
  DEATH_DATETIME				TIMESTAMP		NULL,
  RACE_CONCEPT_ID				INTEGER		  	NOT NULL,
  ETHNICITY_CONCEPT_ID			INTEGER	  		NOT NULL,
  LOCATION_ID					INTEGER		 	NULL,
  PROVIDER_ID					INTEGER		  	NULL,
  CARE_SITE_ID					INTEGER		  	NULL,
  PERSON_SOURCE_VALUE			VARCHAR(50)		NULL,
  GENDER_SOURCE_VALUE			VARCHAR(50)		NULL,
  GENDER_SOURCE_CONCEPT_ID	  	INTEGER		  	NOT NULL,
  RACE_SOURCE_VALUE				VARCHAR(50) 	NULL,
  RACE_SOURCE_CONCEPT_ID		INTEGER		  	NOT NULL,
  ETHNICITY_SOURCE_VALUE		VARCHAR(50) 	NULL,
  ETHNICITY_SOURCE_CONCEPT_ID	INTEGER		  	NOT NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.OBSERVATION_PERIOD  (
  OBSERVATION_PERIOD_ID				BIGINT		NOT NULL ,
  PERSON_ID							BIGINT		NOT NULL ,
  OBSERVATION_PERIOD_START_DATE		DATE		NOT NULL ,
  OBSERVATION_PERIOD_END_DATE		DATE		NOT NULL ,
  PERIOD_TYPE_CONCEPT_ID			INTEGER		NOT NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.SPECIMEN  (
  SPECIMEN_ID					BIGINT			NOT NULL ,
  PERSON_ID						BIGINT			NOT NULL ,
  SPECIMEN_CONCEPT_ID			INTEGER			NOT NULL ,
  SPECIMEN_TYPE_CONCEPT_ID		INTEGER			NOT NULL ,
  SPECIMEN_DATE					DATE			NULL ,
  SPECIMEN_DATETIME				TIMESTAMP		NOT NULL ,
  QUANTITY						FLOAT			NULL ,
  UNIT_CONCEPT_ID				INTEGER			NULL ,
  ANATOMIC_SITE_CONCEPT_ID		INTEGER			NOT NULL ,
  DISEASE_STATUS_CONCEPT_ID		INTEGER			NOT NULL ,
  SPECIMEN_SOURCE_ID			VARCHAR(50)		NULL ,
  SPECIMEN_SOURCE_VALUE			VARCHAR(50)		NULL ,
  UNIT_SOURCE_VALUE				VARCHAR(50)		NULL ,
  ANATOMIC_SITE_SOURCE_VALUE	VARCHAR(50)		NULL ,
  DISEASE_STATUS_SOURCE_VALUE	VARCHAR(50)		NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.VISIT_OCCURRENCE  (
  VISIT_OCCURRENCE_ID			    BIGINT			NOT NULL ,
  PERSON_ID						    BIGINT			NOT NULL ,
  VISIT_CONCEPT_ID				    INTEGER			NOT NULL ,
  VISIT_START_DATE				    DATE			NULL ,
  VISIT_START_DATETIME				TIMESTAMP		NOT NULL ,
  VISIT_END_DATE					DATE			NULL ,
  VISIT_END_DATETIME				TIMESTAMP		NOT NULL ,
  VISIT_TYPE_CONCEPT_ID			    INTEGER			NOT NULL ,
  PROVIDER_ID					    INTEGER			NULL,
  CARE_SITE_ID					    INTEGER			NULL,
  VISIT_SOURCE_VALUE				VARCHAR(50)		NULL,
  VISIT_SOURCE_CONCEPT_ID		    INTEGER			NOT NULL ,
  ADMITTED_FROM_CONCEPT_ID      	INTEGER     	NOT NULL ,   
  ADMITTED_FROM_SOURCE_VALUE    	VARCHAR(50) 	NULL ,
  DISCHARGE_TO_SOURCE_VALUE		  	VARCHAR(50)		NULL ,
  DISCHARGE_TO_CONCEPT_ID		    INTEGER   		NOT NULL ,
  PRECEDING_VISIT_OCCURRENCE_ID		INTEGER			NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.VISIT_DETAIL  (
  VISIT_DETAIL_ID                    BIGINT      NOT NULL ,
  PERSON_ID                          BIGINT      NOT NULL ,
  VISIT_DETAIL_CONCEPT_ID            INTEGER     NOT NULL ,
  VISIT_DETAIL_START_DATE            DATE        NULL ,
  VISIT_DETAIL_START_DATETIME        TIMESTAMP   NOT NULL ,
  VISIT_DETAIL_END_DATE              DATE        NULL ,
  VISIT_DETAIL_END_DATETIME          TIMESTAMP   NOT NULL ,
  VISIT_DETAIL_TYPE_CONCEPT_ID       INTEGER     NOT NULL ,
  PROVIDER_ID                        INTEGER     NULL ,
  CARE_SITE_ID                       INTEGER     NULL ,
  DISCHARGE_TO_CONCEPT_ID            INTEGER     NOT NULL ,
  ADMITTED_FROM_CONCEPT_ID           INTEGER     NOT NULL , 
  ADMITTED_FROM_SOURCE_VALUE         VARCHAR(50) NULL ,
  VISIT_DETAIL_SOURCE_VALUE          VARCHAR(50) NULL ,
  VISIT_DETAIL_SOURCE_CONCEPT_ID     INTEGER     NOT NULL ,
  DISCHARGE_TO_SOURCE_VALUE          VARCHAR(50) NULL ,
  PRECEDING_VISIT_DETAIL_ID          BIGINT      NULL ,
  VISIT_DETAIL_PARENT_ID             BIGINT      NULL ,
  VISIT_OCCURRENCE_ID                BIGINT      NOT NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.PROCEDURE_OCCURRENCE  (
  PROCEDURE_OCCURRENCE_ID		BIGINT			NOT NULL ,
  PERSON_ID						BIGINT			NOT NULL ,
  PROCEDURE_CONCEPT_ID			INTEGER			NOT NULL ,
  PROCEDURE_DATE				DATE			NULL ,
  PROCEDURE_DATETIME			TIMESTAMP		NOT NULL ,
  PROCEDURE_TYPE_CONCEPT_ID		INTEGER			NOT NULL ,
  MODIFIER_CONCEPT_ID			INTEGER			NOT NULL ,
  QUANTITY						INTEGER			NULL ,
  PROVIDER_ID					INTEGER			NULL ,
  VISIT_OCCURRENCE_ID			INTEGER			NULL ,
  VISIT_DETAIL_ID             	INTEGER     	NULL ,
  PROCEDURE_SOURCE_VALUE		VARCHAR(50)		NULL ,
  PROCEDURE_SOURCE_CONCEPT_ID	INTEGER			NOT NULL ,
  MODIFIER_SOURCE_VALUE		    VARCHAR(50)		NULL 
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.DRUG_EXPOSURE  (
  DRUG_EXPOSURE_ID				BIGINT			NOT NULL ,
  PERSON_ID						BIGINT			NOT NULL ,
  DRUG_CONCEPT_ID				INTEGER			NOT NULL ,
  DRUG_EXPOSURE_START_DATE		DATE			NULL ,
  DRUG_EXPOSURE_START_DATETIME	TIMESTAMP		NOT NULL ,
  DRUG_EXPOSURE_END_DATE		DATE			NULL ,
  DRUG_EXPOSURE_END_DATETIME	TIMESTAMP		NOT NULL ,
  VERBATIM_END_DATE				DATE			NULL ,
  DRUG_TYPE_CONCEPT_ID			INTEGER			NOT NULL ,
  STOP_REASON					VARCHAR(20)		NULL ,
  REFILLS						INTEGER		  	NULL ,
  QUANTITY						FLOAT			NULL ,
  DAYS_SUPPLY					INTEGER		  	NULL ,
  SIG							VARCHAR(MAX)	NULL ,
  ROUTE_CONCEPT_ID				INTEGER			NOT NULL ,
  LOT_NUMBER					VARCHAR(50)		NULL ,
  PROVIDER_ID					INTEGER			NULL ,
  VISIT_OCCURRENCE_ID			INTEGER			NULL ,
  VISIT_DETAIL_ID               INTEGER       	NULL ,
  DRUG_SOURCE_VALUE				VARCHAR(50)	  	NULL ,
  DRUG_SOURCE_CONCEPT_ID		INTEGER			NOT NULL ,
  ROUTE_SOURCE_VALUE			VARCHAR(50)	  	NULL ,
  DOSE_UNIT_SOURCE_VALUE		VARCHAR(50)	  	NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.DEVICE_EXPOSURE  (
  DEVICE_EXPOSURE_ID			    BIGINT		  	NOT NULL ,
  PERSON_ID						    BIGINT			NOT NULL ,
  DEVICE_CONCEPT_ID			        INTEGER			NOT NULL ,
  DEVICE_EXPOSURE_START_DATE	    DATE			NULL ,
  DEVICE_EXPOSURE_START_DATETIME	TIMESTAMP		NOT NULL ,
  DEVICE_EXPOSURE_END_DATE		    DATE			NULL ,
  DEVICE_EXPOSURE_END_DATETIME    	TIMESTAMP		NULL ,
  DEVICE_TYPE_CONCEPT_ID		    INTEGER			NOT NULL ,
  UNIQUE_DEVICE_ID			        VARCHAR(50)		NULL ,
  QUANTITY						    INTEGER			NULL ,
  PROVIDER_ID					    INTEGER			NULL ,
  VISIT_OCCURRENCE_ID			    INTEGER			NULL ,
  VISIT_DETAIL_ID                 	INTEGER       	NULL ,
  DEVICE_SOURCE_VALUE			    VARCHAR(100)	NULL ,
  DEVICE_SOURCE_CONCEPT_ID		    INTEGER			NOT NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.CONDITION_OCCURRENCE  (
  CONDITION_OCCURRENCE_ID		    BIGINT			NOT NULL ,
  PERSON_ID						    BIGINT			NOT NULL ,
  CONDITION_CONCEPT_ID			    INTEGER			NOT NULL ,
  CONDITION_START_DATE			    DATE			NULL ,
  CONDITION_START_DATETIME		  	TIMESTAMP		NOT NULL ,
  CONDITION_END_DATE			    DATE			NULL ,
  CONDITION_END_DATETIME		    TIMESTAMP		NULL ,
  CONDITION_TYPE_CONCEPT_ID		  	INTEGER			NOT NULL ,
  CONDITION_STATUS_CONCEPT_ID	  	INTEGER			NOT NULL ,
  STOP_REASON					    VARCHAR(20)		NULL ,
  PROVIDER_ID					    INTEGER			NULL ,
  VISIT_OCCURRENCE_ID			    INTEGER			NULL ,
  VISIT_DETAIL_ID               	INTEGER     	NULL ,
  CONDITION_SOURCE_VALUE		    VARCHAR(50)		NULL ,
  CONDITION_SOURCE_CONCEPT_ID	  	INTEGER			NOT NULL ,
  CONDITION_STATUS_SOURCE_VALUE		VARCHAR(50)		NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.MEASUREMENT  (
  MEASUREMENT_ID				BIGINT			NOT NULL ,
  PERSON_ID						BIGINT			NOT NULL ,
  MEASUREMENT_CONCEPT_ID		INTEGER			NOT NULL ,
  MEASUREMENT_DATE				DATE			NULL ,
  MEASUREMENT_DATETIME			TIMESTAMP		NOT NULL ,
  MEASUREMENT_TIME              VARCHAR(10)		NULL,
  MEASUREMENT_TYPE_CONCEPT_ID	INTEGER			NOT NULL ,
  OPERATOR_CONCEPT_ID			INTEGER			NULL ,
  VALUE_AS_NUMBER				FLOAT			NULL ,
  VALUE_AS_CONCEPT_ID			INTEGER			NULL ,
  UNIT_CONCEPT_ID				INTEGER			NULL ,
  RANGE_LOW					    FLOAT			NULL ,
  RANGE_HIGH					FLOAT			NULL ,
  PROVIDER_ID					INTEGER			NULL ,
  VISIT_OCCURRENCE_ID			INTEGER			NULL ,
  VISIT_DETAIL_ID               INTEGER     	NULL ,
  MEASUREMENT_SOURCE_VALUE		VARCHAR(50)		NULL ,
  MEASUREMENT_SOURCE_CONCEPT_ID	INTEGER			NOT NULL ,
  UNIT_SOURCE_VALUE				VARCHAR(50)		NULL ,
  VALUE_SOURCE_VALUE			VARCHAR(50)		NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.NOTE  (
  NOTE_ID						BIGINT			NOT NULL ,
  PERSON_ID						BIGINT			NOT NULL ,
  NOTE_EVENT_ID         		BIGINT      	NULL , 
  NOTE_EVENT_FIELD_CONCEPT_ID	INTEGER			NOT NULL , 
  NOTE_DATE						DATE			NULL ,
  NOTE_DATETIME					TIMESTAMP		NOT NULL ,
  NOTE_TYPE_CONCEPT_ID			INTEGER			NOT NULL ,
  NOTE_CLASS_CONCEPT_ID 		INTEGER			NOT NULL ,
  NOTE_TITLE					VARCHAR(250)	NULL ,
  NOTE_TEXT						VARCHAR(MAX)	NULL ,
  ENCODING_CONCEPT_ID			INTEGER			NOT NULL ,
  LANGUAGE_CONCEPT_ID			INTEGER			NOT NULL ,
  PROVIDER_ID					INTEGER			NULL ,
  VISIT_OCCURRENCE_ID			INTEGER			NULL ,
  VISIT_DETAIL_ID       		INTEGER       	NULL ,
  NOTE_SOURCE_VALUE				VARCHAR(50)		NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.NOTE_NLP  (
  NOTE_NLP_ID					BIGINT			NOT NULL ,
  NOTE_ID						BIGINT			NOT NULL ,
  SECTION_CONCEPT_ID			INTEGER			NOT NULL ,
  SNIPPET						VARCHAR(250)	NULL ,
  "OFFSET"					    VARCHAR(250)	NULL ,
  LEXICAL_VARIANT				VARCHAR(250)	NOT NULL ,
  NOTE_NLP_CONCEPT_ID			INTEGER			NOT NULL ,
  NLP_SYSTEM					VARCHAR(250)	NULL ,
  NLP_DATE						DATE			NOT NULL ,
  NLP_DATETIME					TIMESTAMP		NULL ,
  TERM_EXISTS					VARCHAR(1)		NULL ,
  TERM_TEMPORAL					VARCHAR(50)		NULL ,
  TERM_MODIFIERS				VARCHAR(2000)	NULL ,
  NOTE_NLP_SOURCE_CONCEPT_ID  	INTEGER			NOT NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.OBSERVATION
 (OBSERVATION_ID					BIGINT			NOT NULL ,
  PERSON_ID						    BIGINT			NOT NULL ,
  OBSERVATION_CONCEPT_ID			INTEGER			NOT NULL ,
  OBSERVATION_DATE				    DATE			NULL ,
  OBSERVATION_DATETIME				TIMESTAMP		NOT NULL ,
  OBSERVATION_TYPE_CONCEPT_ID	    INTEGER			NOT NULL ,
  VALUE_AS_NUMBER				    FLOAT			NULL ,
  VALUE_AS_STRING				    VARCHAR(60)		NULL ,
  VALUE_AS_CONCEPT_ID			    INTEGER			NULL ,
  QUALIFIER_CONCEPT_ID			    INTEGER			NULL ,
  UNIT_CONCEPT_ID				    INTEGER			NULL ,
  PROVIDER_ID					    INTEGER			NULL ,
  VISIT_OCCURRENCE_ID			    BIGINT			NULL ,
  VISIT_DETAIL_ID               	BIGINT      	NULL ,
  OBSERVATION_SOURCE_VALUE		  	VARCHAR(50)		NULL ,
  OBSERVATION_SOURCE_CONCEPT_ID		INTEGER			NOT NULL ,
  UNIT_SOURCE_VALUE				   	VARCHAR(50)		NULL ,
  QUALIFIER_SOURCE_VALUE			VARCHAR(50)		NULL ,
  OBSERVATION_EVENT_ID				BIGINT			NULL , 
  OBS_EVENT_FIELD_CONCEPT_ID		INTEGER			NOT NULL , 
  VALUE_AS_DATETIME					TIMESTAMP		NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE ON KEY(PERSON_ID)
CREATE TABLE cdm_synthea_v53.SURVEY_CONDUCT (
  SURVEY_CONDUCT_ID					BIGINT			NOT NULL ,
  PERSON_ID 						BIGINT			NOT NULL ,
  SURVEY_CONCEPT_ID			  		INTEGER			NOT NULL ,
  SURVEY_START_DATE				    DATE			NULL ,
  SURVEY_START_DATETIME				TIMESTAMP		NULL ,
  SURVEY_END_DATE					DATE			NULL ,
  SURVEY_END_DATETIME				TIMESTAMP		NOT NULL ,
  PROVIDER_ID						BIGINT			NULL ,
  ASSISTED_CONCEPT_ID	  			INTEGER			NOT NULL ,
  RESPONDENT_TYPE_CONCEPT_ID		INTEGER			NOT NULL ,
  TIMING_CONCEPT_ID					INTEGER			NOT NULL ,
  COLLECTION_METHOD_CONCEPT_ID		INTEGER			NOT NULL ,
  ASSISTED_SOURCE_VALUE		  		VARCHAR(50)		NULL ,
  RESPONDENT_TYPE_SOURCE_VALUE		VARCHAR(100)	NULL ,
  TIMING_SOURCE_VALUE				VARCHAR(100)	NULL ,
  COLLECTION_METHOD_SOURCE_VALUE	VARCHAR(100)	NULL ,
  SURVEY_SOURCE_VALUE				VARCHAR(100)	NULL ,
  SURVEY_SOURCE_CONCEPT_ID			INTEGER			NOT NULL ,
  SURVEY_SOURCE_IDENTIFIER			VARCHAR(100)	NULL ,
  VALIDATED_SURVEY_CONCEPT_ID		INTEGER			NOT NULL ,
  VALIDATED_SURVEY_SOURCE_VALUE		VARCHAR(100)	NULL ,
  SURVEY_VERSION_NUMBER				VARCHAR(20)		NULL ,
  VISIT_OCCURRENCE_ID				BIGINT			NULL ,
  VISIT_DETAIL_ID					BIGINT			NULL ,
  RESPONSE_VISIT_OCCURRENCE_ID		BIGINT			NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.FACT_RELATIONSHIP  (
  DOMAIN_CONCEPT_ID_1		INTEGER			NOT NULL ,
  FACT_ID_1					BIGINT			NOT NULL ,
  DOMAIN_CONCEPT_ID_2		INTEGER			NOT NULL ,
  FACT_ID_2					BIGINT			NOT NULL ,
  RELATIONSHIP_CONCEPT_ID	INTEGER			NOT NULL
)
DISTSTYLE ALL;



/************************

STANDARDIZED HEALTH SYSTEM DATA

************************/


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.LOCATION
 (LOCATION_ID				BIGINT			NOT NULL ,
  ADDRESS_1					VARCHAR(50)		NULL ,
  ADDRESS_2					VARCHAR(50)		NULL ,
  CITY						VARCHAR(50)		NULL ,
  STATE						VARCHAR(2)		NULL ,
  ZIP						VARCHAR(9)		NULL ,
  COUNTY					VARCHAR(20)		NULL ,
  COUNTRY					VARCHAR(100)	NULL ,
  LOCATION_SOURCE_VALUE		VARCHAR(50)		NULL ,
  LATITUDE					FLOAT			NULL ,
  LONGITUDE					FLOAT			NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.LOCATION_HISTORY  (
  LOCATION_HISTORY_ID           BIGINT      	NOT NULL ,
  LOCATION_ID			        BIGINT		  	NOT NULL ,
  RELATIONSHIP_TYPE_CONCEPT_ID	INTEGER		  	NOT NULL ,  
  DOMAIN_ID				        VARCHAR(50)		NOT NULL ,
  ENTITY_ID				        BIGINT			NOT NULL ,
  START_DATE			        DATE			NOT NULL ,
  END_DATE				        DATE			NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.CARE_SITE  (
  CARE_SITE_ID						BIGINT			NOT NULL ,
  CARE_SITE_NAME					VARCHAR(255)	NULL ,
  PLACE_OF_SERVICE_CONCEPT_ID	  	INTEGER			NOT NULL ,
  LOCATION_ID						BIGINT			NULL ,
  CARE_SITE_SOURCE_VALUE			VARCHAR(50)		NULL ,
  PLACE_OF_SERVICE_SOURCE_VALUE		VARCHAR(50)		NULL
)
DISTSTYLE ALL;


--HINT DISTRIBUTE ON RANDOM
CREATE TABLE cdm_synthea_v53.PROVIDER  (
  PROVIDER_ID					BIGINT			NOT NULL ,
  PROVIDER_NAME					VARCHAR(255)	NULL ,
  NPI							VARCHAR(20)		NULL ,
  DEA							VARCHAR(20)		NULL ,
  SPECIALTY_CONCEPT_ID			INTEGER			NOT NULL ,
  CARE_SITE_ID					BIGINT			NULL ,
  YEAR_OF_BIRTH					INTEGER			NULL ,
  GENDER_CONCEPT_ID				INTEGER			NOT NULL ,
  PROVIDER_SOURCE_VALUE			VARCHAR(50)		NULL ,
  SPECIALTY_SOURCE_VALUE		VARCHAR(50)		NULL ,
  SPECIALTY_SOURCE_CONCEPT_ID	INTEGER			NULL ,
  GENDER_SOURCE_VALUE			VARCHAR(50)		NULL ,
  GENDER_SOURCE_CONCEPT_ID		INTEGER			NOT NULL
)
DISTSTYLE ALL;


/************************

STANDARDIZED HEALTH ECONOMICS

************************/


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.PAYER_PLAN_PERIOD
 (PAYER_PLAN_PERIOD_ID			BIGINT			NOT NULL ,
  PERSON_ID						BIGINT			NOT NULL ,
  CONTRACT_PERSON_ID            BIGINT        	NULL ,
  PAYER_PLAN_PERIOD_START_DATE  DATE			NOT NULL ,
  PAYER_PLAN_PERIOD_END_DATE	DATE			NOT NULL ,
  PAYER_CONCEPT_ID              INTEGER       	NOT NULL ,
  PLAN_CONCEPT_ID               INTEGER       	NOT NULL ,
  CONTRACT_CONCEPT_ID           INTEGER       	NOT NULL ,
  SPONSOR_CONCEPT_ID            INTEGER       	NOT NULL ,
  STOP_REASON_CONCEPT_ID        INTEGER       	NOT NULL ,
  PAYER_SOURCE_VALUE			VARCHAR(50)	  	NULL ,
  PAYER_SOURCE_CONCEPT_ID       INTEGER       	NOT NULL ,
  PLAN_SOURCE_VALUE				VARCHAR(50)	  	NULL ,
  PLAN_SOURCE_CONCEPT_ID        INTEGER       	NOT NULL ,
  CONTRACT_SOURCE_VALUE         VARCHAR(50)   	NULL ,
  CONTRACT_SOURCE_CONCEPT_ID    INTEGER       	NOT NULL ,
  SPONSOR_SOURCE_VALUE          VARCHAR(50)   	NULL ,
  SPONSOR_SOURCE_CONCEPT_ID     INTEGER       	NOT NULL ,
  FAMILY_SOURCE_VALUE			VARCHAR(50)	  	NULL ,
  STOP_REASON_SOURCE_VALUE      VARCHAR(50)   	NULL ,
  STOP_REASON_SOURCE_CONCEPT_ID INTEGER       	NOT NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE ON KEY(PERSON_ID)
CREATE TABLE cdm_synthea_v53.COST  (
  COST_ID						BIGINT		NOT NULL ,
  PERSON_ID 					BIGINT		NOT NULL,
  COST_EVENT_ID					BIGINT      NOT NULL ,
  COST_EVENT_FIELD_CONCEPT_ID	INTEGER		NOT NULL , 
  COST_CONCEPT_ID				INTEGER		NOT NULL ,
  COST_TYPE_CONCEPT_ID		  	INTEGER     NOT NULL ,
  CURRENCY_CONCEPT_ID			INTEGER		NOT NULL ,
  COST							FLOAT		NULL ,
  INCURRED_DATE					DATE		NOT NULL ,
  BILLED_DATE					DATE		NULL ,
  PAID_DATE						DATE		NULL ,
  REVENUE_CODE_CONCEPT_ID		INTEGER		NOT NULL ,
  DRG_CONCEPT_ID			    INTEGER		NOT NULL ,
  COST_SOURCE_VALUE				VARCHAR(50)	NULL ,
  COST_SOURCE_CONCEPT_ID	  	INTEGER		NOT NULL ,
  REVENUE_CODE_SOURCE_VALUE		VARCHAR(50) NULL ,
  DRG_SOURCE_VALUE			    VARCHAR(3)	NULL ,
  PAYER_PLAN_PERIOD_ID			BIGINT		NULL
)
DISTKEY(PERSON_ID);


/************************

STANDARDIZED DERIVED ELEMENTS

************************/


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.DRUG_ERA  (
  DRUG_ERA_ID				BIGINT			NOT NULL ,
  PERSON_ID					BIGINT			NOT NULL ,
  DRUG_CONCEPT_ID			INTEGER			NOT NULL ,
  DRUG_ERA_START_DATETIME	TIMESTAMP		NOT NULL ,
  DRUG_ERA_END_DATETIME		TIMESTAMP		NOT NULL ,
  DRUG_EXPOSURE_COUNT		INTEGER			NULL ,
  GAP_DAYS					INTEGER			NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.DOSE_ERA  (
  DOSE_ERA_ID				BIGINT		NOT NULL ,
  PERSON_ID					BIGINT		NOT NULL ,
  DRUG_CONCEPT_ID			INTEGER		NOT NULL ,
  UNIT_CONCEPT_ID			INTEGER		NOT NULL ,
  DOSE_VALUE				FLOAT		NOT NULL ,
  DOSE_ERA_START_DATETIME	TIMESTAMP	NOT NULL ,
  DOSE_ERA_END_DATETIME		TIMESTAMP	NOT NULL
)
DISTKEY(PERSON_ID);


--HINT DISTRIBUTE_ON_KEY(PERSON_ID) 
CREATE TABLE cdm_synthea_v53.CONDITION_ERA  (
  CONDITION_ERA_ID					BIGINT			NOT NULL ,
  PERSON_ID							BIGINT			NOT NULL ,
  CONDITION_CONCEPT_ID				INTEGER			NOT NULL ,
  CONDITION_ERA_START_DATETIME		TIMESTAMP		NOT NULL ,
  CONDITION_ERA_END_DATETIME		TIMESTAMP		NOT NULL ,
  CONDITION_OCCURRENCE_COUNT		INTEGER			NULL
)
DISTKEY(PERSON_ID);
