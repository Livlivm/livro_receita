
package com.example.livro_receitas

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class IdeiaWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(
                context.packageName,
                R.layout.ideia_widget
            )

            val ideia = widgetData.getString("ideia", "Ideia") ?: "Ideia"

            views.setTextViewText(R.id.text_ideia, ideia)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
