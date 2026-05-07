/**
 * GOOGLE APPS SCRIPT - BACKEND FOR QR-UID SYSTEM (SECURED)
 * 
 * Instructions:
 * 1. Create a Google Sheet.
 * 2. Rename Sheet1 to "Devices" and add columns: UID, Name, Location.
 * 3. Add another sheet named "Logs" and add columns: Timestamp, UID, Items, Notes, User.
 * 4. Open Extensions > Apps Script.
 * 5. Paste this code and Deploy as Web App (Execute as: Me, Access: Anyone).
 */

const SHEET_ID = SpreadsheetApp.getActiveSpreadsheet().getId();
const API_TOKEN = "HAPU_QR_SECRET_2026"; // Simple security token

function doGet(e) {
  const token = e.parameter.token;
  const uid = e.parameter.uid;

  // Security Check
  if (token !== API_TOKEN) {
    return contentResponse({ status: "error", message: "Unauthorized access" });
  }

  if (!uid) return contentResponse({ status: "error", message: "Missing UID" });

  const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName("Devices");
  const data = sheet.getDataRange().getValues();
  
  for (let i = 1; i < data.length; i++) {
    if (data[i][0] == uid) {
      return contentResponse({
        status: "success",
        data: {
          uid: data[i][0],
          name: data[i][1],
          location: data[i][2]
        }
      });
    }
  }

  return contentResponse({ status: "not_found", message: "Device not found" });
}

function doPost(e) {
  try {
    const params = JSON.parse(e.postData.contents);
    
    // Security Check
    if (params.token !== API_TOKEN) {
      return contentResponse({ status: "error", message: "Unauthorized access" });
    }

    const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName("Logs");
    
    sheet.appendRow([
      new Date(),
      params.uid,
      JSON.stringify(params.items),
      params.notes,
      "Mobile User"
    ]);

    return contentResponse({ status: "success" });
  } catch (err) {
    return contentResponse({ status: "error", message: err.toString() });
  }
}

function contentResponse(obj) {
  return ContentService.createTextOutput(JSON.stringify(obj))
    .setMimeType(ContentService.MimeType.JSON);
}
