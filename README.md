# BMSN Membership Management System — Stage 1 (foundation)
1. Create a Supabase project. Copy `.env.example` to `.env` and fill it in (service-role key stays server-side).
2. Run `supabase/schema.sql` in the Supabase SQL editor.
3. `npm install` then `npm run geo:import` (loads data/geo.csv: 4 LGAs, 43 wards, 1,437 polling units).
4. Create the admin: `ADMIN_PASSWORD='your-long-password' npm run admin:create -- "Your Name" you@example.com super_admin`
Assets: `public/logo.png` (BMSN logo, use everywhere) and `public/favicon.png`.
The admin account made in the browser demo does not carry over; create it again in step 4.
Stage 2 (Next.js pages, APIs, ID card, admin dashboard) is built on this schema.
