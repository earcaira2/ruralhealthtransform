const router = require('express').Router();
const prisma  = require('../../lib/prisma');

/**
 * GET /api/pricing
 * Query params:
 *   facility  — filter by facility ID (integer)
 *   category  — filter by service line category name (string, partial match)
 *   cpt       — filter by CPT code (exact)
 *   flag      — filter by rate_flag ('strong' | 'moderate' | 'limited')
 *   page      — page number (default 1)
 *   limit     — records per page (default 50, max 500)
 */
router.get('/', async (req, res) => {
  try {
    const { facility, category, cpt, flag } = req.query;
    const page  = Math.max(1, parseInt(req.query.page)  || 1);
    const limit = Math.min(500, Math.max(1, parseInt(req.query.limit) || 50));
    const skip  = (page - 1) * limit;

    const where = {};
    if (facility) where.facilityId    = facility;
    if (cpt)      where.cpt_code      = cpt;
    if (flag)     where.rate_flag     = flag;
    if (category) where.category      = { contains: category, mode: 'insensitive' };

    const [records, total] = await Promise.all([
      prisma.pricingRecord.findMany({
        where,
        skip,
        take: limit,
        orderBy: [{ facility: { name: 'asc' } }, { cpt_code: 'asc' }],
        include: {
          facility:    { select: { id: true, name: true, cms_id: true } },
          serviceLine: { select: { id: true, code: true, name: true } }
        }
      }),
      prisma.pricingRecord.count({ where })
    ]);

    res.json({
      data: records,
      meta: {
        total,
        page,
        limit,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * GET /api/pricing/summary
 * Returns aggregate stats per facility + category
 */
router.get('/summary', async (req, res) => {
  try {
    const summary = await prisma.pricingRecord.groupBy({
      by: ['facilityId', 'category'],
      _count: { id: true },
      _avg:   { gross_charge: true, cash_price: true, neg_min: true, neg_max: true },
      orderBy: { facilityId: 'asc' }
    });

    // Attach facility names
    const facilityIds = [...new Set(summary.map(s => s.facilityId))];
    const facilities  = await prisma.facility.findMany({
      where: { id: { in: facilityIds } },
      select: { id: true, name: true }
    });
    const facMap = Object.fromEntries(facilities.map(f => [f.id, f.name]));

    const result = summary.map(s => ({
      facilityId:   s.facilityId,
      facilityName: facMap[s.facilityId] || 'Unknown',
      category:     s.category,
      count:        s._count.id,
      avg: {
        gross_charge: s._avg.gross_charge,
        cash_price:   s._avg.cash_price,
        neg_min:      s._avg.neg_min,
        neg_max:      s._avg.neg_max
      }
    }));

    res.json({ data: result, meta: { total: result.length } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * GET /api/pricing/categories
 * Returns distinct categories with record counts
 */
router.get('/categories', async (req, res) => {
  try {
    const cats = await prisma.pricingRecord.groupBy({
      by: ['category'],
      _count: { id: true },
      orderBy: { category: 'asc' }
    });
    res.json({
      data: cats.map(c => ({ category: c.category, count: c._count.id }))
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * GET /api/pricing/:id
 * Single record by PK
 */
router.get('/:id', async (req, res) => {
  try {
    const record = await prisma.pricingRecord.findUnique({
      where:   { id: req.params.id },
      include: { facility: true, serviceLine: true }
    });
    if (!record) return res.status(404).json({ error: 'Record not found' });
    res.json({ data: record });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
