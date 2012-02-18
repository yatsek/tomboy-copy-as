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

namespace Tomboy.CopyAs
{
        public class CopyAsAddin : NoteAddin
        {
                Gtk.MenuItem mainItem;
		Hashtable transformByMenuItem = new Hashtable();
		String[] initialXslFiles = {"CopyAs-Trac.xsl", "CopyAs-PmWiki.xsl", "CopyAs-MediaWiki.xsl", "CopyAs-MoinMoin.xsl"};

		static CopyAsAddin ()
		{
		}

                public override void Initialize ()
                {
 			Assembly asm = Assembly.GetExecutingAssembly ();
			string asm_dir = System.IO.Path.GetDirectoryName (asm.Location);

			string[] xslFiles = System.IO.Directory.GetFiles(asm_dir, "CopyAs-*.xsl");
			if (xslFiles.Length == 0) {
				// copy initial files to add-in dir
				foreach (string xslFile in initialXslFiles) {
					Stream resource = asm.GetManifestResourceStream (xslFile);
					Stream dest = new FileStream(Path.Combine (asm_dir, xslFile), FileMode.OpenOrCreate, FileAccess.Write);

					byte[] buf = new byte[4096];
					while (true) {
						int n = resource.Read(buf, 0, buf.Length);
						if (n == 0) {
							break;
						}
						dest.Write(buf, 0, n);
					}
					dest.Close();
				}
				// list copied files
				xslFiles = System.IO.Directory.GetFiles(asm_dir, "CopyAs-*.xsl");
			}
			
			Menu menu = new Menu();
			foreach (string xslFile in xslFiles) {
				if (mainItem == null) {
					mainItem = new Gtk.MenuItem (Catalog.GetString ("Copy as"));
					mainItem.Show ();
 					AddPluginMenuItem (mainItem);
					mainItem.Submenu = menu;
				}
				string menuName = xslFile.Substring(xslFile.IndexOf("-") + 1);
				menuName = menuName.Substring(0, menuName.Length - 4);
                       		MenuItem subItem = new Gtk.MenuItem (Catalog.GetString (menuName));
				subItem.Show();
                        	subItem.Activated += OnMenuItemActivated;
				menu.Append(subItem);

				string stylesheet_file = Path.Combine (asm_dir, xslFile);
				XslTransform xsl = new XslTransform ();
				xsl.Load (stylesheet_file);
				transformByMenuItem.Add(subItem, xsl);
			}

                }

                public override void Shutdown ()
                {
			Menu menu = (Menu)mainItem.Submenu;
			foreach (MenuItem item in menu.Children) {
	                        item.Activated -= OnMenuItemActivated;
			}
                }

                public override void OnNoteOpened ()
                {
                }

                void OnMenuItemActivated (object sender, EventArgs args)
                {
			XslTransform xsl = (XslTransform)transformByMenuItem[sender];
			TextWriter writer = new StringWriter();
			WriteHTMLForNote (xsl, writer, Note, false, false);
			Gtk.Clipboard cb = Gtk.Clipboard.Get(Gdk.Atom.Intern("CLIPBOARD", true));
			cb.Text = writer.ToString();
                }

		public void WriteHTMLForNote (XslTransform xsl,
						TextWriter writer,
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

