#include <Godot.hpp>
#include <Gradient.hpp>
#include <Image.hpp>
#include <Reference.hpp>
#include <iostream>
#include <thread>
using namespace std;

using namespace godot;

class SimpleClass : public Reference {
  GODOT_CLASS(SimpleClass, Reference);

public:
  // Construtor
  SimpleClass() {}

  // Construtor chamado pela Engine
  void _init() { Godot::print("A Lib_SimpleClass Funcionou Como Deveria"); }

  void MetodoDeExemplo() { Godot::print("Apenas um teste"); }

  Variant method(Variant arg) {
    Variant ret;
    ret = arg;

    return ret;
  }

  static void _register_methods() {
    register_method("method", &SimpleClass::method);
    register_method("MetodoDeExemplo", &SimpleClass::MetodoDeExemplo);
    /**
     * The line below is equivalent to the following GDScript export:
     *     export var _name = "SimpleClass"
     **/
    register_property<SimpleClass, String>("base/name", &SimpleClass::_name,
                                           String("SimpleClass"));

    /** Alternatively, with getter and setter methods: */
    register_property<SimpleClass, int>("base/value", &SimpleClass::set_value,
                                        &SimpleClass::get_value, 0);

    /** Registering a signal: **/
    // register_signal<SimpleClass>("signal_name");
    // register_signal<SimpleClass>("signal_name", "string_argument",
    // GODOT_VARIANT_TYPE_STRING)
  }

  String _name;
  int _value;

  void set_value(int p_value) { _value = p_value; }

  int get_value() const { return _value; }
};

/** GDNative Initialize **/
extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *o) {
  godot::Godot::gdnative_init(o);
}

/** GDNative Terminate **/
extern "C" void GDN_EXPORT
godot_gdnative_terminate(godot_gdnative_terminate_options *o) {
  godot::Godot::gdnative_terminate(o);
}

/** NativeScript Initialize **/
extern "C" void GDN_EXPORT godot_nativescript_init(void *handle) {
  godot::Godot::nativescript_init(handle);

  godot::register_class<SimpleClass>();
}
