const API = 'https://web-production-1af7c.up.railway.app/api';

const pages = {
  home: 'hompage.html',
  audio: 'audio.html',
  laptops: 'laptops.html',
  smartphones: 'smartphones.html',
  accessories: 'accessories.html',
  about: 'about.html',
  cart: 'cart.html',
  login: 'login.html'
};

// ── Auth helpers ──────────────────────────────────────────
function getToken() { return sessionStorage.getItem('token'); }
function getUserName() { return sessionStorage.getItem('userName'); }
function isLoggedIn() { return !!getToken(); }

function logout() {
  sessionStorage.removeItem('token');
  sessionStorage.removeItem('userName');
  sessionStorage.removeItem('cart');
  window.location.href = pages.login;
}

// ── Cart helpers ──────────────────────────────────────────
function getCart() {
  return JSON.parse(sessionStorage.getItem('cart') || '[]');
}

function saveCart(cart) {
  sessionStorage.setItem('cart', JSON.stringify(cart));
}

function updateCartBadge() {
  const count = getCart().reduce((sum, i) => sum + (i.qty || 1), 0);
  document.querySelectorAll('.cart-count').forEach(el => {
    el.textContent = count;
  });
}

// ── Toast ─────────────────────────────────────────────────
function showToast(message) {
  let toast = document.getElementById('toast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'toast';
    toast.style.cssText = `
      position:fixed;bottom:28px;right:28px;
      background:#0e1118;border:1px solid #1c1f2b;
      color:#d8d8d8;font-family:'Inter',sans-serif;
      font-size:0.82rem;font-weight:400;
      padding:12px 18px;border-radius:7px;
      box-shadow:0 6px 24px rgba(0,0,0,0.5);
      z-index:9999;opacity:0;
      transition:opacity 0.25s;
      pointer-events:none;max-width:260px;
    `;
    document.body.appendChild(toast);
  }
  toast.textContent = message;
  toast.style.opacity = '1';
  clearTimeout(toast._timer);
  toast._timer = setTimeout(() => { toast.style.opacity = '0'; }, 2200);
}

// ── Add to cart ───────────────────────────────────────────
async function addToCart(btn) {
  if (!isLoggedIn()) {
    showToast('Please login to add to cart');
    setTimeout(() => { window.location.href = pages.login; }, 1200);
    return;
  }

  const card = btn.closest('.card');
  const name  = card.querySelector('.card-name')?.textContent.trim() || '';
  const price = card.querySelector('.card-price')?.textContent.trim() || '';
  const productId = card.dataset.productId;

  try {
    const res = await fetch(`${API}/cart/add`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${getToken()}`
      },
      body: JSON.stringify({ product_id: parseInt(productId) })
    });

    if (res.ok) {
      // Also update local sessionStorage for badge count
      const cart = getCart();
      const existing = cart.find(i => i.name === name);
      if (existing) {
        existing.qty = (existing.qty || 1) + 1;
      } else {
        cart.push({ name, price, qty: 1 });
      }
      saveCart(cart);
      updateCartBadge();

      btn.textContent = 'Added ✓';
      btn.classList.add('added');
      setTimeout(() => {
        btn.textContent = 'Add to Cart';
        btn.classList.remove('added');
      }, 1800);

      showToast(name + ' added to cart');
    } else if (res.status === 401) {
      showToast('Session expired, please login again');
      setTimeout(() => { window.location.href = pages.login; }, 1200);
    }
  } catch {
    showToast('Could not connect to server');
  }
}

// ── Update nav based on login state ──────────────────────
function updateNav() {
  const nav = document.querySelector('.header-nav');
  if (!nav) return;

  const loginLink = nav.querySelector('.nav-login');
  const logoutLink = nav.querySelector('.nav-logout');
  const userSpan = nav.querySelector('.nav-user');

  if (isLoggedIn()) {
    if (loginLink) loginLink.style.display = 'none';
    if (logoutLink) logoutLink.style.display = 'inline';
    if (userSpan) userSpan.textContent = getUserName();
  } else {
    if (loginLink) loginLink.style.display = 'inline';
    if (logoutLink) logoutLink.style.display = 'none';
    if (userSpan) userSpan.textContent = '';
  }
}

updateCartBadge();
updateNav();

// ── Sidebar filter links ──────────────────────────────────
document.querySelectorAll('.v-sidebar li').forEach(li => {
  li.addEventListener('click', () => {
    document.querySelectorAll('.v-sidebar li').forEach(l => l.classList.remove('active'));
    li.classList.add('active');
  });
});

// ── Search ────────────────────────────────────────────────
const searchForm  = document.querySelector('.search-bar');
const searchInput = searchForm?.querySelector('input');

if (searchForm) {
  searchForm.addEventListener('submit', e => {
    e.preventDefault();
    const query = searchInput?.value.trim().toLowerCase();
    if (!query) return;

    const cards = document.querySelectorAll('.card');
    let found = 0;
    cards.forEach(card => {
      const name  = card.querySelector('.card-name')?.textContent.toLowerCase() || '';
      const desc  = card.querySelector('.card-desc')?.textContent.toLowerCase() || '';
      const cat   = card.querySelector('.card-cat')?.textContent.toLowerCase() || '';
      const match = name.includes(query) || desc.includes(query) || cat.includes(query);
      card.style.display = match ? '' : 'none';
      if (match) found++;
    });

    if (found === 0) {
      cards.forEach(card => { card.style.display = ''; });
      searchInput.value = '';
      searchInput.placeholder = 'Nothing matched — showing all';
      setTimeout(() => {
        searchInput.placeholder = searchInput.dataset.placeholder || 'Search...';
      }, 2500);
    }
  });

  if (searchInput) {
    searchInput.dataset.placeholder = searchInput.placeholder;
    searchInput.addEventListener('input', () => {
      if (searchInput.value === '') {
        document.querySelectorAll('.card').forEach(card => { card.style.display = ''; });
      }
    });
  }
}