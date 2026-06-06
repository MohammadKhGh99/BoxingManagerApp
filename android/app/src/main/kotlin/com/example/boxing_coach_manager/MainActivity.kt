package com.example.boxing_coach_manager

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream

class MainActivity : FlutterActivity() {
	private val backupChannelName = "boxing_coach_manager/backup_storage"
	private val legacyBackupChannelName = "boxing_coach_manage/backup_storage"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		registerBackupChannel(flutterEngine, backupChannelName)
		registerBackupChannel(flutterEngine, legacyBackupChannelName)
	}

	private fun registerBackupChannel(flutterEngine: FlutterEngine, channelName: String) {
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"saveBackup", "saveBytes" -> {
						val sourcePath = call.argument<String>("sourcePath")
						val fileName = call.argument<String>("fileName")
						val subDir = call.argument<String>("subDir") ?: "BoxingManager"

						if (sourcePath.isNullOrBlank() || fileName.isNullOrBlank()) {
							result.error("INVALID_ARGUMENT", "Missing backup source or file name", null)
							return@setMethodCallHandler
						}

						try {
							val savedPath = saveBackupToDownloads(sourcePath, fileName, subDir)
							result.success(savedPath)
						} catch (exception: Exception) {
							result.error("SAVE_FAILED", exception.message, null)
						}
					}
					else -> result.notImplemented()
				}
			}
	}

	private fun saveBackupToDownloads(sourcePath: String, fileName: String, subDir: String): String {
		val sourceFile = File(sourcePath)
		if (!sourceFile.exists()) {
			throw IllegalArgumentException("Source backup file does not exist")
		}

		return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
			saveBackupWithMediaStore(sourceFile, fileName, subDir)
		} else {
			saveBackupWithFileSystem(sourceFile, fileName, subDir)
		}
	}

	private fun saveBackupWithMediaStore(sourceFile: File, fileName: String, subDir: String): String {
		val resolver = applicationContext.contentResolver
		val contentValues = ContentValues().apply {
			put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
			put(MediaStore.MediaColumns.MIME_TYPE, "application/octet-stream")
			put(
				MediaStore.MediaColumns.RELATIVE_PATH,
				Environment.DIRECTORY_DOWNLOADS + "/" + subDir
			)
		}

		val collection = MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
		val itemUri = resolver.insert(collection, contentValues)
			?: throw IllegalStateException("Unable to create backup file in public storage")

		resolver.openOutputStream(itemUri, "w")?.use { outputStream ->
			FileInputStream(sourceFile).use { inputStream ->
				inputStream.copyTo(outputStream)
			}
		} ?: throw IllegalStateException("Unable to open output stream for backup file")

		return File(
			Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS),
			"$subDir/$fileName"
		).path
	}

	private fun saveBackupWithFileSystem(sourceFile: File, fileName: String, subDir: String): String {
		val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
		val backupDir = File(downloadsDir, subDir)
		if (!backupDir.exists() && !backupDir.mkdirs()) {
			throw IllegalStateException("Unable to create backup folder")
		}

		val destinationFile = File(backupDir, fileName)
		sourceFile.copyTo(destinationFile, overwrite = true)
		return destinationFile.path
	}
}
