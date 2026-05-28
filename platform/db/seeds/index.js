const { PrismaClient } = require('@prisma/client');
const path = require('path');

const prisma = new PrismaClient({
  datasources: { db: { url: process.env.DATABASE_URL } }
});

async function main() {
  console.log('🌱 RHTP Platform — Data Seeder');
  console.log('================================');

  await seedPricing();

  console.log('\n✅ Seeding complete.');
}

async function seedPricing() {
  console.log('\n📦 Seeding pricing records...');

  const dataPath = path.join(__dirname, '..', '..', '..', '..', 'Dashboards', 'pricing_data.json');
  const records  = require(dataPath);

  // Upsert facilities first
  const hospitalNames = [...new Set(records.map(r => r.h))];
  console.log(`   Found ${hospitalNames.length} unique hospitals`);

  // We need a placeholder state + county for now (Montana FIPS = 30)
  // Real county assignment comes when we load the facility master list
  let state = await prisma.state.upsert({
    where:  { fips: '30' },
    update: {},
    create: { fips: '30', name: 'Montana', abbreviation: 'MT' }
  });

  let county = await prisma.county.upsert({
    where:  { fips: '30000' },
    update: {},
    create: { fips: '30000', name: 'Montana (Unassigned)', stateId: state.id }
  });

  // Upsert each facility
  const facilityMap = {};
  for (const name of hospitalNames) {
    const facility = await prisma.facility.upsert({
      where:  { cms_id: `MT-${name.replace(/\s+/g, '-').substring(0, 30)}` },
      update: { name },
      create: {
        cms_id:   `MT-${name.replace(/\s+/g, '-').substring(0, 30)}`,
        name,
        type:     'Hospital',
        countyId: county.id,
        stateId:  state.id,
        is_rhtp:  true
      }
    });
    facilityMap[name] = facility.id;
  }
  console.log(`   ✓ ${hospitalNames.length} facilities upserted`);

  // Upsert service lines (categories)
  const categories = [...new Set(records.map(r => r.cat))];
  const serviceLineMap = {};
  for (const cat of categories) {
    const sl = await prisma.serviceLine.upsert({
      where:  { code: cat.replace(/\s*\/\s*/g, '_').replace(/\s+/g, '_').toUpperCase() },
      update: { name: cat },
      create: {
        code:     cat.replace(/\s*\/\s*/g, '_').replace(/\s+/g, '_').toUpperCase(),
        name:     cat,
        category: 'Clinical'
      }
    });
    serviceLineMap[cat] = sl.id;
  }
  console.log(`   ✓ ${categories.length} service lines upserted`);

  // Batch insert pricing records
  let inserted = 0;
  let skipped  = 0;

  for (const r of records) {
    try {
      await prisma.pricingRecord.create({
        data: {
          facilityId:    facilityMap[r.h],
          serviceLineId: serviceLineMap[r.cat],
          cpt_code:      r.c,
          procedure:     r.p,
          category:      r.cat,
          gross_charge:  r.g   ?? null,
          cash_price:    r.ca  ?? null,
          neg_min:       r.n1  ?? null,
          neg_max:       r.n2  ?? null,
          medicare_rate: r.mr  ?? null,
          rate_flag:     r.f   ?? null,
          n_records:     r.nr  ?? null,
          year:          2024
        }
      });
      inserted++;
    } catch (err) {
      if (err.code === 'P2002') { skipped++; } // duplicate
      else { console.warn(`   ⚠ Record skipped: ${r.h} / ${r.c} — ${err.message}`); skipped++; }
    }
  }

  console.log(`   ✓ ${inserted} pricing records inserted, ${skipped} skipped`);
}

main()
  .catch(e => { console.error('❌ Seed failed:', e); process.exit(1); })
  .finally(() => prisma.$disconnect());
