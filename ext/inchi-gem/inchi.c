#include <ruby.h>
#include <inchi_api.h>
#include <string.h>


typedef struct {
    int    returnCode;
    VALUE  message; 
    VALUE  log;
    VALUE  auxInfo;
} rb_ExtraInchiReturnValues;

static void
rb_eirv_free(void *ptr)
{
    ruby_xfree(ptr);
}

static const rb_data_type_t rb_eirv_type = {
    "ExtraInchiReturnValues",
    {0, rb_eirv_free, 0},
    0, 0,
    RUBY_TYPED_FREE_IMMEDIATELY
};

static VALUE
rb_eirv_alloc(VALUE klass)
{
    rb_ExtraInchiReturnValues *p;
    VALUE obj = TypedData_Make_Struct(klass, rb_ExtraInchiReturnValues,
                                      &rb_eirv_type, p);
    p->returnCode = 0;
    p->message    = Qnil;
    p->log        = Qnil;
    p->auxInfo    = Qnil;
    return obj;
}

static void
fix_option_symbols(const char *in, char *out)
{
    const char *s = in;
    char *d = out;
    while ((*d = *s)) {
#ifdef _WIN32
        if (*d == '-') *d = '/';
#else
        if (*d == '/') *d = '-';
#endif
        ++d; ++s;
    }
}

static VALUE
rb_molfile_to_inchi(int argc, VALUE *argv, VALUE self)
{
    VALUE rb_mol, rb_rv, rb_opts;
    rb_scan_args(argc, argv, "21", &rb_mol, &rb_rv, &rb_opts);
    if (NIL_P(rb_opts)) rb_opts = rb_str_new2("");

    Check_Type(rb_mol,  T_STRING);
    Check_Type(rb_opts, T_STRING);

    rb_ExtraInchiReturnValues *rv;
    TypedData_Get_Struct(rb_rv, rb_ExtraInchiReturnValues,
                         &rb_eirv_type, rv);

    const char *mol_text = RSTRING_PTR(rb_mol);
    const char *opts_in  = RSTRING_LEN(rb_opts) ? RSTRING_PTR(rb_opts) : NULL;

    char *opts_copy = NULL;
    if (opts_in) {
        opts_copy = ALLOCA_N(char, RSTRING_LEN(rb_opts) + 1);
        fix_option_symbols(opts_in, opts_copy);
    }

    inchi_Output out;
    memset(&out, 0, sizeof(out));

    int ret = MakeINCHIFromMolfileText(mol_text, opts_copy, &out);

    rv->returnCode = ret;
    rv->message = (out.szMessage ? rb_str_new2(out.szMessage) : Qnil);
    rv->log     = (out.szLog     ? rb_str_new2(out.szLog)     : Qnil);
    rv->auxInfo = (out.szAuxInfo ? rb_str_new2(out.szAuxInfo) : Qnil);
    VALUE result = out.szInChI ? rb_str_new2(out.szInChI) : rb_str_new2("");
    FreeINCHI(&out);
    return result;
}

static VALUE
rb_inchi_to_inchi_key(VALUE self, VALUE rb_inchi)
{
    Check_Type(rb_inchi, T_STRING);
    const char *inchi = RSTRING_PTR(rb_inchi);

    char inchi_key[29], xtra1[65], xtra2[65];
    int rc = GetINCHIKeyFromINCHI(inchi, 0, 0, inchi_key, xtra1, xtra2);

    if (rc == INCHIKEY_OK)
        return rb_str_new2(inchi_key);

    return Qnil;
}

void
Init_inchi(void)
{
    VALUE mInchi = rb_define_module("Inchi");

    VALUE cRV = rb_define_class_under(mInchi, "ExtraInchiReturnValues", rb_cObject);
    rb_define_alloc_func(cRV, rb_eirv_alloc);
    rb_define_attr(cRV, "returnCode", 1, 1);
    rb_define_attr(cRV, "message",    1, 1);
    rb_define_attr(cRV, "log",        1, 1);
    rb_define_attr(cRV, "auxInfo",    1, 1);

    rb_define_module_function(mInchi, "molfileToInchi",
                            rb_molfile_to_inchi, -1);
    rb_define_module_function(mInchi, "InchiToInchiKey",
                            rb_inchi_to_inchi_key, 1);
}
