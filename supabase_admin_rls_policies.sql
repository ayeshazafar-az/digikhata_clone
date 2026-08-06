-- Supabase RLS Policies for Digikhata Admin Panel (FIXED FOR INFINITE RECURSION)
-- Provide these commands into your Supabase SQL snippet editor to update the live Admin Panel 

-- First, create a secure function that bypasses RLS to check for admin status
-- This prevents the "infinite recursion" error when querying the profiles table!
CREATE OR REPLACE FUNCTION public.is_super_admin()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS(
    SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin'
  );
$$;

-- 1. PROFILES: Prevent infinite recursion by using the new function
DROP POLICY IF EXISTS "Super Admins can view all profiles" ON profiles;
CREATE POLICY "Super Admins can view all profiles" 
ON profiles 
FOR SELECT 
TO authenticated 
USING (
  is_super_admin() OR id = auth.uid()
);

DROP POLICY IF EXISTS "Super Admins can update all profiles" ON profiles;
CREATE POLICY "Super Admins can update all profiles" 
ON profiles 
FOR UPDATE 
TO authenticated 
USING (
  is_super_admin()
);


-- 2. BUSINESSES: Update this to use the safe function as well
DROP POLICY IF EXISTS "Super Admins can view all businesses" ON businesses;
CREATE POLICY "Super Admins can view all businesses" 
ON businesses 
FOR SELECT 
TO authenticated 
USING (
  is_super_admin() OR owner_id = auth.uid()
);

DROP POLICY IF EXISTS "Super Admins can update all businesses" ON businesses;
CREATE POLICY "Super Admins can update all businesses" 
ON businesses 
FOR UPDATE 
TO authenticated 
USING (
  is_super_admin()
);

-- 3. FAQS: System wide configurations
CREATE TABLE IF NOT EXISTS faqs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category TEXT NOT NULL,
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Allow anyone reading FAQs
DROP POLICY IF EXISTS "Public read access for FAQs" ON faqs;
CREATE POLICY "Public read access for FAQs"
ON faqs FOR SELECT TO public USING (true);

-- Allow super admins to manipulate FAQs
DROP POLICY IF EXISTS "Admins can manage FAQs" ON faqs;
CREATE POLICY "Admins can manage FAQs"
ON faqs FOR ALL TO authenticated USING (
  is_super_admin()
);

-- 4. BAZAR PRODUCTS: Dynamic Wholesale Marketplace
CREATE TABLE IF NOT EXISTS bazar_products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_name TEXT NOT NULL,
  title TEXT NOT NULL,
  price NUMERIC NOT NULL,
  old_price NUMERIC,
  discount TEXT,
  image_url TEXT NOT NULL,
  moq INTEGER DEFAULT 1,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Allow public read access to marketplace
DROP POLICY IF EXISTS "Public read access for bazar" ON bazar_products;
CREATE POLICY "Public read access for bazar"
ON bazar_products FOR SELECT TO public USING (true);

-- Allow Admins to manage products
DROP POLICY IF EXISTS "Admins can manage bazar" ON bazar_products;
CREATE POLICY "Admins can manage bazar"
ON bazar_products FOR ALL TO authenticated USING (is_super_admin());

-- Seed Mock Marketplace Data
INSERT INTO bazar_products (brand_name, title, price, old_price, discount, image_url, moq)
VALUES 
  ('Khaadi', 'Women Embroidered Lawn Suit', 3990, 5000, '20% OFF', 'https://images.unsplash.com/photo-1583391733958-65e2820c5db6?w=400&q=80', 3),
  ('J.', 'Men Classic Kurta Shalwar', 4500, 5500, 'Sale', 'https://images.unsplash.com/photo-1603217039640-aa46b0add751?w=400&q=80', 5),
  ('Nishat', 'Printed Linen 3-Piece', 4200, null, null, 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&q=80', 5),
  ('Bonanza', 'Winter Khaddar Collection', 3200, 4000, '20% OFF', 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=400&q=80', 10),
  ('Khaadi', 'Printed Cambric Shirt', 2100, 2500, 'Clearance', 'https://images.unsplash.com/photo-1551488831-00ddcb6c6bd3?w=400&q=80', 3),
  ('J.', 'Junaid Jamshed Exclusive Scent', 3500, null, null, 'https://images.unsplash.com/photo-1594032194509-0056023973b2?w=400&q=80', 2),
  ('Nishat', 'Luxury Festive Collection', 8500, 10000, 'New Arrival', 'https://images.unsplash.com/photo-1584273143981-41c073dfe8f8?w=400&q=80', 2)
ON CONFLICT DO NOTHING;