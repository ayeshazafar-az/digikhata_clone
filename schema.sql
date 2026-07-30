-- Run this in the Supabase SQL Editor to configure the project schema

-- Businesses Table
CREATE TABLE public.businesses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  name TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Customers Table
CREATE TABLE public.customers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  business_id UUID REFERENCES public.businesses(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  phone TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Transactions Table
CREATE TABLE public.transactions (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  customer_id UUID REFERENCES public.customers(id) ON DELETE CASCADE NOT NULL,
  business_id UUID REFERENCES public.businesses(id) ON DELETE CASCADE NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('credit', 'debit')), -- credit = cash in (user got money), debit = cash out (user gave money)
  amount NUMERIC(10, 2) NOT NULL,
  note TEXT,
  date TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Set up Row Level Security (RLS)
ALTER TABLE public.businesses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transactions ENABLE ROW LEVEL SECURITY;

-- Policies for businesses
CREATE POLICY "Users can manage their own businesses" 
ON public.businesses FOR ALL 
USING (auth.uid() = user_id);

-- Policies for customers
CREATE POLICY "Users can manage customers in their businesses" 
ON public.customers FOR ALL 
USING (business_id IN (SELECT id FROM public.businesses WHERE user_id = auth.uid()));

-- Policies for transactions
CREATE POLICY "Users can manage transactions in their businesses" 
ON public.transactions FOR ALL 
USING (business_id IN (SELECT id FROM public.businesses WHERE user_id = auth.uid()));
