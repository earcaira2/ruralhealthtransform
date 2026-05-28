const router = require('express').Router();
const prisma  = require('../../lib/prisma');

/**
 * GET /api/facilities
 * Query params:
 *   state   — filter by state abbreviation (e.g. 'MT')
 *   type    — filter by facility type ('Hospital', 'CAH', etc.)
 *   rhtp    — filter RHTP-designated only ('true')
 */
router.get('/', async (req, res) => {
  try {
    const { state, type, rhtp } = req.query;
    const where = {};
    if (type) where.type    = { contains: type, mode: 'insensitive' };
    if (rhtp === 'true') where.is_rhtp = true;
    if (state) where.state  = { abbreviation: { equals: state, mode: 'insensitive' } };

    const facilities = await prisma.facility.findMany({
      where,
      orderBy: { name: 'asc' },
      include: {
        state:   { select: { abbreviation: true, name: true } },
        county:  { select: { name: true, fips: true } },
        _count:  { select: { pricingRecords: true } }
      }
    });

    res.json({ data: facilities, meta: { total: facilities.length } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * GET /api/facilities/:id
 * Single facility with all pricing records
 */
router.get('/:id', async (req, res) => {
  try {
    const facility = await prisma.facility.findUnique({
      where:   { id: req.params.id },
      include: {
        state:   true,
        county:  true,
        pricingRecords: {
          orderBy: { cpt_code: 'asc' }
        },
        _count: {
          select: { pricingRecords: true }
        }
      }
    });
    if (!facility) return res.status(404).json({ error: 'Facility not found' });
    res.json({ data: facility });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
