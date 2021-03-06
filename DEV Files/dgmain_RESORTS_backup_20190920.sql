PGDMP     $    #                w           DGD     11.5 (Ubuntu 11.5-1.pgdg18.04+1)     11.5 (Ubuntu 11.5-1.pgdg18.04+1)     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    16393    DGD    DATABASE     w   CREATE DATABASE "DGD" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE "DGD";
             dgadmin    false            �            1259    16454    resorts    TABLE     �   CREATE TABLE dgmain.resorts (
    resort_id integer NOT NULL,
    location text,
    resort_name text,
    resort_type text,
    rooms text[],
    dining jsonb[],
    entertainment jsonb[]
);
    DROP TABLE dgmain.resorts;
       dgmain         dgadmin    false            �           0    0    TABLE resorts    ACL     q   REVOKE ALL ON TABLE dgmain.resorts FROM dgadmin;
GRANT ALL ON TABLE dgmain.resorts TO dgadmin WITH GRANT OPTION;
            dgmain       dgadmin    false    220            �          0    16454    resorts 
   TABLE DATA               n   COPY dgmain.resorts (resort_id, location, resort_name, resort_type, rooms, dining, entertainment) FROM stdin;
    dgmain       dgadmin    false    220   �       x           2606    16461    resorts resorts_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY dgmain.resorts
    ADD CONSTRAINT resorts_pkey PRIMARY KEY (resort_id);
 >   ALTER TABLE ONLY dgmain.resorts DROP CONSTRAINT resorts_pkey;
       dgmain         dgadmin    false    220            �   g  x��\�n����<�"?�8I.���?K����X�|1��?#q%mEq�%iG)�;�
�G��orO�o��DR�%;A���Yr�;��7��~�����ͣ�J"�>J�I�S2bk�&�J&���{
3��Op)
��J�Փo����Ic���sII*^�e��[�����_�D�����?^G�����j���L�o?at]���q	?�(���H�P���Mw���(����,
\�︭�Rqb�H�2b��*�z��s�ň҅C�B�*����@�.�`u��83���)��z��O�_~�X���_b��*���㩑2j^��7��&��R�H~��I"��������m\�X�K_LA�����cY=+:�(�D��\�+)C1̢�E~z���꒏���҄���z�c142�.�_22�4�.4H)��)���^�;� ^����X����J��[3*>w���+qj��i�$4�YHbjJ�Y&�i��C��ڬ]C���>���~�M��ѧU<S����MB�#q=��T��t��Vf��;X�9&V\d��
�k��ct��Tf<L��������L�DjE��t���<WiBoiV�Qǟ\C��i�µg*�	����ޗ{�U��wr����&�00:��Y����K~�aH���Φ��	S�3�����E^�ס��x��5��ev��c	LJ�5�j�> ������J��������x��K��ea��\��:ɡ��sL�MWY�$�	'�D�*�9��R�X���|&Zg�O�:N��4�w:�G44x�e�(���c=�Ţ/�43��~.��=3�}Q�Dh �������F2���j}������>ڇ5�8���Gs�Cm�x��DX�����[���wdZ����y~Yl��,���/b��Rϫ���FGh<��[�\bO��7:u
�����Oj�g��d:����^��,�0oA�)M(\�(l�D`�3��ɝ��P"��W�qŷY���>�E�mef�cvB�i-=fO�ړ,aHX��\���(�T���}�Iq�>8T2���)����XM�ȅ��&��f$�����.����:wy�����P9���xa�؉44�񂑟�o�Ǌ>ġ6�u@�7�
��װ��J�L��j�Co>xX�G�����2q�!Nc9'8I@�LRB�ˇ�m���fz0�	��Sơ����J(�hS}ĕ^�N3��>�7h��B�@E����簆/�9
O�9}�"�u1�Nf�N�v�b��Тc�D�	�5��t&��<~���
�^�<~qЀo_��o@�iA�P�]���.����kX/M�yڅ�T��ㅾ��A�pIK@{����2<b!�&�$������kѾ*��3B����DGܩej=I��6k ��C	g�70�ą.�ޣ�e�u.oe�Hv�w��E'�*VS�*�+�pc7=y@���
K.���������b�k����L[2gXp5e:�("��}!+�1x���@�t�����Ŋ�m�o����AI&���JK<��p����K��y��L����x�f�Bh�z�.L�f� "#��Ě1pz�<c�h���054Kˀ G��#�x��¥xE{N�ŷ+I|ݙ.m6���.��������'�?�f�'�!�����(��!�>�~J�%�<�[��p����|�!������h�Qb+�VK,<���9�6'���(��;_�y�mE�C�aEX�>��g��[��M�㉭7���?��QQ��"\��ǧ���kp_xb?1�2�v#YklܹB�r�����
i/|�C&�F�=s�����=�V�6�Z�.H���q.Eכ"��&����l�q�R��M��d���W/��8&���S��GnW`%�7	�V|��e��$�gW�cGs�H��[��7/�dj���Y��u��Ĥ*�dhD�LS'�1yL�L��艹�*f�3@�!t�%��S'`�v#
�x��ō�����΅��%��ܺ� B��w�}����n���@�����-OL���U�����<_ص.�k�j�ͨ�+m��:֜�[ B���`�\�e��g�ݓ��e"���&��Vh��F6���5���KŞzӥ*3���TT��e�&W��)��N2+��M$s'~\K6��_t�|�,�!9��d��F�ג������W��.|.R�6�``���I�Nj��l�����b���w�pJILƆ����Ӯ��z�>F��������I"��"��4�O�I8Aw�n"���ԣ5E�	t@輆�xT^2���PNy�����oDsI����^�z2)į�Y��멒�����85��^���Z@
�]y����(ΐS��\���Z���
q������r��l�����O�m���/Xz,zY�,��S��bW>�,4��t�\'v���A��
���v���(������ P���~ʅJbiۧh�K���	j�d��]��Db!Ǐ8�.�GN��	v��� ���y^tO���zP~h�a� j�.Zw��7{s��z�~�ԫZ����߭���p{����|���q���۪��P�F1(NA-1�j�K6��"Y쿝��d�'���$��'�J�ї��je�.i�����_;V�q��ԳZ�b�d�+���[���ڹ�{|�u���P߿��޼bU�˷*^�i�
$4�`�-A�[�9ô���~��J�$����=�do[��P��4�m%��f��p��nש��<�&p� `}���6u��p&xf���-�q�C'�F�Q$-R�7O�٩:�9B_#ث�����P����>�dޖ�+��6��3����kf?�"֐����k�1�;���R٪��0Cq�������5��)�]��Xg@e��kÊ��
�Hy<�:oyF����3��p�;1�h���Յ���6&�l�����!;z��k��VP�.%~w�-��|�{�2�!�M����g :n7���E ��4��-]6\�G�� �me~_�}�6R;����zZG���z�j�g$D�x�<4����	W��Q%#g�Ʃgv��?��f���G���F\)��e���y��	ۿ5F+z�M�£Z�n�ywj��s*^p�Bq����}ǒ�,��� �q_�i���� ���r]f��'�|�_?�'��m\���-w�ls���jm��+��n �����s�W��χ����E��{�{zE�����9 f��X�Ps;�]T��Wo����ު����������M�����9���I�@������a���G�m�|H\�j�8�O�W�l�i�\�]�&�Z�.��g��N�J��ANx�br5�-�1�@���?�Խ@3d#�1�S���Q�����D����}�n�Sp~��B�g���7��E#K,���Q����tF��Bj�����a�-�����a��MҢ�u�&P��|�Mu�9�B5�ck����������0eo(���Zos-��t+D/v�� �e���w�����>�~bO
׶s�ީ�y�Pʹ���HM]��t��3�I����W����!kd�Q�����q��;�:
׮��.�Z��>0����;F �(�3��E�jU��}fޮK��ۿl�\Iۈ�~Ԛ�7����lm��O� ���ȁY�m����=t�3M��A�`�Z��b��9-f^G���[��A��� �6ۘy�0^��R>�� l��z^?����y��v�p�W6�ʵ=�v̽�`���i3��y��K�|��2r�u���Gq�'�~������igK���w�8$�3�,�����t�#>�\��Oѡxj�����'�����wS.�(�h��v*�d��BZM���ib_�e��1=�i���_����rbx���a8��~�Z�Gҡ$|j����F����$-�	�_������c"�
     