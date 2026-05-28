-- CreateTable
CREATE TABLE "State" (
    "id" TEXT NOT NULL,
    "fips" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "abbreviation" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "State_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "County" (
    "id" TEXT NOT NULL,
    "fips" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "stateId" TEXT NOT NULL,
    "population" INTEGER,
    "areasqmi" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "County_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ServiceLine" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "canTelehealth" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ServiceLine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PayerType" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PayerType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Facility" (
    "id" TEXT NOT NULL,
    "cms_id" TEXT,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "is_cah" BOOLEAN NOT NULL DEFAULT false,
    "is_rhtp" BOOLEAN NOT NULL DEFAULT false,
    "countyId" TEXT NOT NULL,
    "stateId" TEXT NOT NULL,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "address" TEXT,
    "beds" INTEGER,
    "telehealth" BOOLEAN NOT NULL DEFAULT false,
    "status" TEXT NOT NULL DEFAULT 'active',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Facility_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FacilityService" (
    "id" TEXT NOT NULL,
    "facilityId" TEXT NOT NULL,
    "serviceLineId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'active',
    "volume" INTEGER,
    "revenue" DOUBLE PRECISION,
    "cost" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "FacilityService_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "FacilityFinancial" (
    "id" TEXT NOT NULL,
    "facilityId" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "total_revenue" DOUBLE PRECISION,
    "net_patient_revenue" DOUBLE PRECISION,
    "total_expenses" DOUBLE PRECISION,
    "operating_income" DOUBLE PRECISION,
    "operating_margin_pct" DOUBLE PRECISION,
    "total_margin_pct" DOUBLE PRECISION,
    "medicare_margin_pct" DOUBLE PRECISION,
    "days_cash_on_hand" DOUBLE PRECISION,
    "current_ratio" DOUBLE PRECISION,
    "long_term_debt_pct" DOUBLE PRECISION,
    "fte_total" DOUBLE PRECISION,
    "source" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "FacilityFinancial_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PayerMix" (
    "id" TEXT NOT NULL,
    "facilityId" TEXT NOT NULL,
    "payerTypeId" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "pct" DOUBLE PRECISION NOT NULL,
    "revenue" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PayerMix_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PricingRecord" (
    "id" TEXT NOT NULL,
    "facilityId" TEXT NOT NULL,
    "serviceLineId" TEXT,
    "cpt_code" TEXT NOT NULL,
    "procedure" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "gross_charge" DOUBLE PRECISION,
    "cash_price" DOUBLE PRECISION,
    "neg_min" DOUBLE PRECISION,
    "neg_max" DOUBLE PRECISION,
    "medicare_rate" DOUBLE PRECISION,
    "rate_flag" TEXT,
    "n_records" INTEGER,
    "year" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PricingRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CostCenter" (
    "id" TEXT NOT NULL,
    "facilityId" TEXT NOT NULL,
    "serviceLineId" TEXT,
    "year" INTEGER NOT NULL,
    "cost_center" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "total_charges" DOUBLE PRECISION,
    "total_costs" DOUBLE PRECISION,
    "net_revenue" DOUBLE PRECISION,
    "rcc" DOUBLE PRECISION,
    "source" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CostCenter_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PatientFlow" (
    "id" TEXT NOT NULL,
    "originId" TEXT NOT NULL,
    "destinationId" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "volume" INTEGER NOT NULL,
    "pct_of_origin" DOUBLE PRECISION,
    "service_type" TEXT,
    "source" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PatientFlow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DriveTime" (
    "id" TEXT NOT NULL,
    "countyId" TEXT NOT NULL,
    "facilityId" TEXT NOT NULL,
    "minutes" DOUBLE PRECISION NOT NULL,
    "miles" DOUBLE PRECISION,
    "source" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DriveTime_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HealthOutcome" (
    "id" TEXT NOT NULL,
    "countyId" TEXT NOT NULL,
    "measure" TEXT NOT NULL,
    "value" DOUBLE PRECISION NOT NULL,
    "year" INTEGER NOT NULL,
    "source" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "HealthOutcome_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CountyDemographic" (
    "id" TEXT NOT NULL,
    "countyId" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "total_pop" INTEGER,
    "pop_under18" DOUBLE PRECISION,
    "pop_65plus" DOUBLE PRECISION,
    "pop_rural_pct" DOUBLE PRECISION,
    "median_income" DOUBLE PRECISION,
    "poverty_pct" DOUBLE PRECISION,
    "uninsured_pct" DOUBLE PRECISION,
    "source" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CountyDemographic_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Scenario" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "status" TEXT NOT NULL DEFAULT 'draft',
    "baseYear" INTEGER NOT NULL DEFAULT 2024,
    "createdBy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Scenario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScenarioAssumption" (
    "id" TEXT NOT NULL,
    "scenarioId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "facilityId" TEXT,
    "serviceLineId" TEXT,
    "parameter" TEXT NOT NULL,
    "value" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ScenarioAssumption_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScenarioResult" (
    "id" TEXT NOT NULL,
    "scenarioId" TEXT NOT NULL,
    "facilityId" TEXT,
    "metric" TEXT NOT NULL,
    "baseline" DOUBLE PRECISION,
    "projected" DOUBLE PRECISION,
    "delta" DOUBLE PRECISION,
    "delta_pct" DOUBLE PRECISION,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ScenarioResult_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NetworkState" (
    "id" TEXT NOT NULL,
    "scenarioId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "NetworkState_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NetworkNode" (
    "id" TEXT NOT NULL,
    "networkStateId" TEXT NOT NULL,
    "facilityId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'active',
    "services" JSONB NOT NULL,
    "metrics" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "NetworkNode_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NetworkEdge" (
    "id" TEXT NOT NULL,
    "networkStateId" TEXT NOT NULL,
    "originId" TEXT NOT NULL,
    "destinationId" TEXT NOT NULL,
    "volume" DOUBLE PRECISION NOT NULL,
    "pct" DOUBLE PRECISION NOT NULL,
    "type" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "NetworkEdge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Recommendation" (
    "id" TEXT NOT NULL,
    "scenarioId" TEXT,
    "facilityId" TEXT,
    "countyId" TEXT,
    "type" TEXT NOT NULL,
    "priority" TEXT NOT NULL,
    "stakeholder" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "financial_impact" DOUBLE PRECISION,
    "access_impact" DOUBLE PRECISION,
    "health_impact" DOUBLE PRECISION,
    "feasibility" TEXT,
    "timeframe" TEXT,
    "policy_levers" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Recommendation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ParetoFrontier" (
    "id" TEXT NOT NULL,
    "scenarioId" TEXT NOT NULL,
    "label" TEXT NOT NULL,
    "weights" JSONB NOT NULL,
    "points" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ParetoFrontier_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "State_fips_key" ON "State"("fips");

-- CreateIndex
CREATE UNIQUE INDEX "State_abbreviation_key" ON "State"("abbreviation");

-- CreateIndex
CREATE UNIQUE INDEX "County_fips_key" ON "County"("fips");

-- CreateIndex
CREATE UNIQUE INDEX "ServiceLine_code_key" ON "ServiceLine"("code");

-- CreateIndex
CREATE UNIQUE INDEX "PayerType_code_key" ON "PayerType"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Facility_cms_id_key" ON "Facility"("cms_id");

-- CreateIndex
CREATE UNIQUE INDEX "FacilityService_facilityId_serviceLineId_key" ON "FacilityService"("facilityId", "serviceLineId");

-- CreateIndex
CREATE UNIQUE INDEX "FacilityFinancial_facilityId_year_key" ON "FacilityFinancial"("facilityId", "year");

-- CreateIndex
CREATE UNIQUE INDEX "PayerMix_facilityId_payerTypeId_year_key" ON "PayerMix"("facilityId", "payerTypeId", "year");

-- CreateIndex
CREATE UNIQUE INDEX "PatientFlow_originId_destinationId_year_service_type_key" ON "PatientFlow"("originId", "destinationId", "year", "service_type");

-- CreateIndex
CREATE UNIQUE INDEX "DriveTime_countyId_facilityId_key" ON "DriveTime"("countyId", "facilityId");

-- CreateIndex
CREATE UNIQUE INDEX "HealthOutcome_countyId_measure_year_key" ON "HealthOutcome"("countyId", "measure", "year");

-- CreateIndex
CREATE UNIQUE INDEX "CountyDemographic_countyId_year_key" ON "CountyDemographic"("countyId", "year");

-- AddForeignKey
ALTER TABLE "County" ADD CONSTRAINT "County_stateId_fkey" FOREIGN KEY ("stateId") REFERENCES "State"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Facility" ADD CONSTRAINT "Facility_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "County"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Facility" ADD CONSTRAINT "Facility_stateId_fkey" FOREIGN KEY ("stateId") REFERENCES "State"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FacilityService" ADD CONSTRAINT "FacilityService_facilityId_fkey" FOREIGN KEY ("facilityId") REFERENCES "Facility"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FacilityService" ADD CONSTRAINT "FacilityService_serviceLineId_fkey" FOREIGN KEY ("serviceLineId") REFERENCES "ServiceLine"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "FacilityFinancial" ADD CONSTRAINT "FacilityFinancial_facilityId_fkey" FOREIGN KEY ("facilityId") REFERENCES "Facility"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PayerMix" ADD CONSTRAINT "PayerMix_facilityId_fkey" FOREIGN KEY ("facilityId") REFERENCES "Facility"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PayerMix" ADD CONSTRAINT "PayerMix_payerTypeId_fkey" FOREIGN KEY ("payerTypeId") REFERENCES "PayerType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PricingRecord" ADD CONSTRAINT "PricingRecord_facilityId_fkey" FOREIGN KEY ("facilityId") REFERENCES "Facility"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PricingRecord" ADD CONSTRAINT "PricingRecord_serviceLineId_fkey" FOREIGN KEY ("serviceLineId") REFERENCES "ServiceLine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CostCenter" ADD CONSTRAINT "CostCenter_facilityId_fkey" FOREIGN KEY ("facilityId") REFERENCES "Facility"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CostCenter" ADD CONSTRAINT "CostCenter_serviceLineId_fkey" FOREIGN KEY ("serviceLineId") REFERENCES "ServiceLine"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PatientFlow" ADD CONSTRAINT "PatientFlow_originId_fkey" FOREIGN KEY ("originId") REFERENCES "Facility"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PatientFlow" ADD CONSTRAINT "PatientFlow_destinationId_fkey" FOREIGN KEY ("destinationId") REFERENCES "Facility"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DriveTime" ADD CONSTRAINT "DriveTime_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "County"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DriveTime" ADD CONSTRAINT "DriveTime_facilityId_fkey" FOREIGN KEY ("facilityId") REFERENCES "Facility"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HealthOutcome" ADD CONSTRAINT "HealthOutcome_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "County"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CountyDemographic" ADD CONSTRAINT "CountyDemographic_countyId_fkey" FOREIGN KEY ("countyId") REFERENCES "County"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScenarioAssumption" ADD CONSTRAINT "ScenarioAssumption_scenarioId_fkey" FOREIGN KEY ("scenarioId") REFERENCES "Scenario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScenarioResult" ADD CONSTRAINT "ScenarioResult_scenarioId_fkey" FOREIGN KEY ("scenarioId") REFERENCES "Scenario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NetworkState" ADD CONSTRAINT "NetworkState_scenarioId_fkey" FOREIGN KEY ("scenarioId") REFERENCES "Scenario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NetworkNode" ADD CONSTRAINT "NetworkNode_networkStateId_fkey" FOREIGN KEY ("networkStateId") REFERENCES "NetworkState"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NetworkNode" ADD CONSTRAINT "NetworkNode_facilityId_fkey" FOREIGN KEY ("facilityId") REFERENCES "Facility"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NetworkEdge" ADD CONSTRAINT "NetworkEdge_networkStateId_fkey" FOREIGN KEY ("networkStateId") REFERENCES "NetworkState"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NetworkEdge" ADD CONSTRAINT "NetworkEdge_originId_fkey" FOREIGN KEY ("originId") REFERENCES "NetworkNode"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NetworkEdge" ADD CONSTRAINT "NetworkEdge_destinationId_fkey" FOREIGN KEY ("destinationId") REFERENCES "NetworkNode"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
