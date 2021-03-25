CREATE TABLE public.user (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30),
    age INT
);

INSERT INTO public.user (name, age) VALUES ('sample_user1', 30);
INSERT INTO public.user (name, age) VALUES ('sample_user2', 31);
INSERT INTO public.user (name, age) VALUES ('sample_user3', 32);
INSERT INTO public.user (name, age) VALUES ('sample_user4', 33);
INSERT INTO public.user (name, age) VALUES ('sample_user5', 34);
