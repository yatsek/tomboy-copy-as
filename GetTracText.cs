using System;
using Mono.Unix;
using Gtk;
using Tomboy;
using System.IO;
using System.Collections;
using System.Reflection;
using System.Xml;
using System.Xml.XPath;
using System.Xml.Xsl;

namespace Tomboy.GetTracText
{
        public class GetTracTextAddin : NoteAddin
        {
		const string stylesheet_name = "GetTracText.xsl";
		static XslTransform xsl;
                Gtk.MenuItem item;

		static GetTracTextAddin ()
		{
			Assembly asm = Assembly.GetExecutingAssembly ();
			string asm_dir = System.IO.Path.GetDirectoryName (asm.Location);
			string stylesheet_file = Path.Combine (asm_dir, stylesheet_name);

			xsl = new XslTransform ();

			if (File.Exists (stylesheet_file)) {
				Logger.Log ("GetTracText: Using user-custom {0} file.",
				            stylesheet_name);
				xsl.Load (stylesheet_file);
			} else {
				Stream resource = asm.GetManifestResourceStream (stylesheet_name);
				if (resource != null) {
					XmlTextReader reader = new XmlTextReader (resource);
					xsl.Load (reader, null, null);
					resource.Close ();
				} else {
					Logger.Log ("Unable to find HTML export template '{0}'.",
					            stylesheet_name);
				}
			}
		}

                public override void Initialize ()
                {
                        item = new Gtk.MenuItem (Catalog.GetString ("Get as Trac text"));
                        item.Activated += OnMenuItemActivated;
                        item.Show ();
                        AddPluginMenuItem (item);
                }

                public override void Shutdown ()
                {
                        item.Activated -= OnMenuItemActivated;
                }

                public override void OnNoteOpened ()
                {
                }

                void OnMenuItemActivated (object sender, EventArgs args)
                {
			TextWriter writer = new StringWriter();
			WriteHTMLForNote (writer, Note, false, false);
			Gtk.Clipboard cb = Gtk.Clipboard.Get(Gdk.Atom.Intern("CLIPBOARD", true));
			cb.Text = writer.ToString();
                }

		public void WriteHTMLForNote (TextWriter writer,
		                              Note note,
		                              bool export_linked,
		                              bool export_linked_all)
		{
			// NOTE: Don't use the XmlDocument version, which strips
			// whitespace between elements for some reason.  Also,
			// XPathDocument is faster.
			StringWriter s_writer = new StringWriter ();
			NoteArchiver.Write (s_writer, note.Data);
			StringReader reader = new StringReader (s_writer.ToString ());
			s_writer.Close ();
			XPathDocument doc = new XPathDocument (reader);
			reader.Close ();

			XsltArgumentList args = new XsltArgumentList ();
			args.AddParam ("export-linked", "", export_linked);
			args.AddParam ("export-linked-all", "", export_linked_all);
			args.AddParam ("root-note", "", note.Title);

			if ((bool) Preferences.Get (Preferences.ENABLE_CUSTOM_FONT)) {
				string font_face = (string) Preferences.Get (Preferences.CUSTOM_FONT_FACE);
				Pango.FontDescription font_desc =
				        Pango.FontDescription.FromString (font_face);
				string font = String.Format ("font-family:'{0}';", font_desc.Family);

				args.AddParam ("font", "", font);
			}

			xsl.Transform (doc, args, writer);
		}
        }
}

