const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
async function main() {
  const pricing    = await prisma.pricingRecord.count();
  const facilities = await prisma.facility.count();
  const services   = await prisma.serviceLine.count();
  console.log('✅ Database verification');
  console.log('  PricingRecords : ' + pricing);
  console.log('  Facilities     : ' + facilities);
  console.log('  ServiceLines   : ' + services);
  const sample = await prisma.pricingRecord.findFirst({
    include: { facility: true, serviceLine: true }
  });
  console.log('\n  Sample record:');
  console.log('    Hospital  : ' + sample.facility.name);
  console.log('    CPT       : ' + sample.cpt_code);
  console.log('    Procedure : ' + sample.procedure);
  console.log('    Category  : ' + sample.category);
  console.log('    Rate flag : ' + sample.rate_flag);
  await prisma.$disconnect();
}
main().catch(e => { console.error(e); process.exit(1); });
