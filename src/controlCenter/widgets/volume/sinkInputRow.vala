namespace SwayNotificationCenter.Widgets {
    public class SinkInputRow : Gtk.ListBoxRow {

        Gtk.Box container;
        Gtk.Image icon = new Gtk.Image ();
        Gtk.Scale scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 100, 1);

        public unowned PulseSinkInput sink_input;

        private unowned PulseDaemon client;

        public SinkInputRow (PulseSinkInput sink_input, PulseDaemon client, int icon_size) {
            this.client = client;

            update (sink_input);

            scale.draw_value = false;
            scale.hexpand = true;

            icon.pixel_size = icon_size;
            icon.set_tooltip_text (sink_input.get_display_name ());

            container = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            container.append (icon);
            container.append (scale);

            set_child (container);

            scale.value_changed.connect (() => {
                client.set_sink_input_volume (sink_input, (float) scale.get_value ());
                scale.tooltip_text = ((int) scale.get_value ()).to_string ();
            });
        }

        public void update (PulseSinkInput sink_input) {
            this.sink_input = sink_input;

            icon.set_pixel_size (64);
            icon.set_from_icon_name (
                sink_input.application_icon_name ?? "application-x-executable");

            scale.set_value (sink_input.volume);
            scale.tooltip_text = ((int) scale.get_value ()).to_string ();
        }
    }
}
