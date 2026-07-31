-- Run this inside your Supabase SQL Editor to prepare the database for Phase 5 Mega Modules

-- 1. PRODUCTS TABLE (Stock Book)
CREATE TABLE public.products (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  business_id uuid NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  item_name text NOT NULL,
  unit text NOT NULL DEFAULT 'pcs',
  selling_price numeric NOT NULL DEFAULT 0,
  purchase_price numeric NOT NULL DEFAULT 0,
  opening_stock numeric NOT NULL DEFAULT 0,
  current_stock numeric NOT NULL DEFAULT 0,
  created_at timestamp with time zone DEFAULT now()
);
ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage products for their businesses" ON public.products FOR ALL USING (
  business_id IN (SELECT id FROM public.businesses WHERE owner_id = auth.uid())
);

-- 2. CASHBOOK ENTRIES TABLE (Physical Drawer Cash)
CREATE TABLE public.cashbook_entries (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  business_id uuid NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  entry_type text NOT NULL CHECK (entry_type IN ('cash_in', 'cash_out')),
  amount numeric NOT NULL,
  remark text,
  created_at timestamp with time zone DEFAULT now()
);
ALTER TABLE public.cashbook_entries ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage cashbook for their businesses" ON public.cashbook_entries FOR ALL USING (
  business_id IN (SELECT id FROM public.businesses WHERE owner_id = auth.uid())
);

-- 3. STAFF TABLE (Staff Book / Attendance)
CREATE TABLE public.staff (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  business_id uuid NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  name text NOT NULL,
  phone text,
  monthly_salary numeric NOT NULL DEFAULT 0,
  created_at timestamp with time zone DEFAULT now()
);
ALTER TABLE public.staff ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage staff for their businesses" ON public.staff FOR ALL USING (
  business_id IN (SELECT id FROM public.businesses WHERE owner_id = auth.uid())
);

-- 4. BILLS TABLE (Bill Book / Invoicing)
CREATE TABLE public.bills (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  business_id uuid NOT NULL REFERENCES public.businesses(id) ON DELETE CASCADE,
  customer_name text NOT NULL,
  customer_phone text,
  total_amount numeric NOT NULL DEFAULT 0,
  status text NOT NULL DEFAULT 'unpaid',
  created_at timestamp with time zone DEFAULT now()
);
ALTER TABLE public.bills ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage bills for their businesses" ON public.bills FOR ALL USING (
  business_id IN (SELECT id FROM public.businesses WHERE owner_id = auth.uid())
);
