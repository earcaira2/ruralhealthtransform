const router = require('express').Router();

// GET all
router.get('/', async (req, res) => {
  try {
    res.json({ route: 'pricing', status: 'stub - not yet implemented' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
