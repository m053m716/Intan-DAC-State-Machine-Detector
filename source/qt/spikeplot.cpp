//  ------------------------------------------------------------------------
//
//  This file is part of the Intan Technologies RHS2000 Interface
//  Version 1.01
//  Copyright (C) 2013-2017 Intan Technologies
//
//  ------------------------------------------------------------------------
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published
//  by the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#include <QtGui>
#if QT_VERSION >= QT_VERSION_CHECK(5,0,0)
#include <QtWidgets>
#endif
#include <qmath.h>
#include <iostream>
#include <vector>

#include "globalconstants.h"
#include "signalprocessor.h"
#include "signalchannel.h"
#include "spikescopedialog.h"
#include "spikeplot.h"


// The SpikePlot widget displays a triggered neural spike plot in the
// Spike Scope dialog.  Multiple spikes are plotted on top of one another
// so users may compare their shapes.  The RMS value of the waveform is
// displayed in the plot.  Users may select a new threshold value by clicking
// on the plot.  Keypresses are used to change the voltage scale of the plot.

SpikePlot::SpikePlot(SignalProcessor *inSignalProcessor, SignalChannel *initialChannel, SignalChannel *curDacChannel,
                     SpikeScopeDialog *inSpikeScopeDialog, QWidget *parent, double fs) :
    QWidget(parent)
{
    // Store properties as passed to constructor
    signalProcessor = inSignalProcessor;
    spikeScopeDialog = inSpikeScopeDialog;
    selectedDacChannel = curDacChannel;
    selectedChannel = initialChannel;

    // Initialize properties associated with the FSM
    initGenProperties();

    // Initialize pen colors for different types of snippets
    initPenColors();

    // Initialize display properties for this window
    initDisplay();

    // Initialize spike axes
    setSampleRate(fs);
}

// Set voltage scale.
void SpikePlot::setYScale(int newYScale)
{
    yScale = newYScale;
    initSpikeAxes();
}
// Set waveform sample rate.
void SpikePlot::setSampleRate(double newSampleRate)
{
    // Calculate time step, in msec.
    tStepMsec = 1000.0 / newSampleRate;

    // Calculate number of time steps in SPIKE_WINDOW_T msec sample.
    totalTSteps = qCeil(SPIKE_WINDOW_T / tStepMsec) + 1;

    // Calculate number of time steps in the SPIKE_WINDOW_PRE_TRIGGER msec pre-trigger
    // display interval.
    preTriggerTSteps = qCeil(SPIKE_WINDOW_PRE_TRIGGER / tStepMsec);

    // Clear old waveforms since the sample rate has changed.
    numSpikeWaveforms = 0;
    startingNewChannel = true;

    // Initialize buffers for snippets to be plotted from data streams
    initBuffers();

    // Initialize graphical axes
    initSpikeAxes();
}
// set current DAC channel
void SpikePlot::setCurrentChannel(int channel)
{
    if (channel < 0 || channel > 7) {
        cerr << "Error in SpikePlot::setCurrentChannel: channel (" << channel << ") out of range." << endl;
        return;
    }
    thisChannel = channel;
    reDrawFSMLevels(); // re-draw new "thick" line
}
// set whether this window is enabled
void SpikePlot::setWEnable(bool enable)
{
    if (thisChannel < 0 || thisChannel > 7) {
        cerr << "Error in SpikePlot::setWEnable: thisChannel (" << thisChannel << ") out of range." << endl;
        return;
    }
    wEnable[thisChannel] = enable;
    reDrawFSMLevels(); // some lines may disappear or re-appear
}
// set the start sample for this channel's state window
void SpikePlot::setWStart(int sample)
{
    if (thisChannel < 0 || thisChannel > 7) {
        cerr << "Error in SpikePlot::setWStart: thisChannel (" << thisChannel << ") out of range." << endl;
        return;
    }

    if (sample < 0 || sample > 1000) {
        cerr << "Error in SpikePlot::setWStart: sample (" << sample << ") out of range." << endl;
        return;
    }
    wStart[thisChannel] = sample;
    updateLevelStartStop(); // offsets may change
}
// set the stop sample for this channel's state window
void SpikePlot::setWStop(int sample)
{
    if (thisChannel < 0 || thisChannel > 7) {
        cerr << "Error in SpikePlot::setWStop: thisChannel (" << thisChannel << ") out of range." << endl;
        return;
    }

    if (sample < 0 || sample > 1000) {
        cerr << "Error in SpikePlot::setWStop: sample (" << sample << ") out of range." << endl;
        return;
    }
    wStop[thisChannel] = sample;
    updateLevelStartStop(); // offsets may change
}
// set full duration of state machine
void SpikePlot::setWMax(int sample)
{
    if (sample < 0 || sample > 1000) {
        cerr << "Error in SpikePlot::setWMax: sample (" << sample << ") out of range." << endl;
        return;
    }
    wMax = sample;
    updateLevelStartStop();
}
// set threshold for current channel from dropdown combo box of dialog
void SpikePlot::setWThresh(int threshold)
{
    if (thisChannel < 0 || thisChannel > 7) {
        cerr << "Error in SpikePlot::setWThresh: thisChannel (" << thisChannel << ") out of range." << endl;
        return;
    }

    if (threshold < -5000 || threshold > 5000) {
        cerr << "Error in SpikePlot::setWThresh: threshold (" << threshold << ") out of range." << endl;
        return;
    }
    wThresh[thisChannel] = threshold;
    updateLevelStartStop();
}
// set include or exclude window type
void SpikePlot::setWType(int type)
{
    // check that channel is in range
    if (thisChannel < 0 || thisChannel > 7) {
        cerr << "Error in SpikePlot::setWType: thisChannel (" << thisChannel << ") out of range." << endl;
        return;
    }

    // check that type index is appropriate
    if (type < 0 || type > 1) {
        cerr << "Error in SpikePlot::setWType: type (" << type << ") out of range." << endl;
        return;
    }

    wType[thisChannel] = type;
    reDrawFSMLevels(); // change colors
}
// listen for whether state machine is enabled
void SpikePlot::setWMode(bool fsmOn)
{
    fsmModeOn = fsmOn;
    initSpikeAxes();
    updateLevelStartStop(); // toggle the lines on or off
}

// GRAPHICS: UPDATE LINES DRAWN FOR FSM //

// Draw text around axes.
void SpikePlot::reDrawText()
{

    QPainter painter(&pixmap);
    painter.initFrom(this);

    // Get text box width and height
    const int tbWidth = painter.fontMetrics().width("ONLY AMPLIFIER CHANNELS CAN BE DISPLAYED");
    const int tbHeight = painter.fontMetrics().height();

    // Clear entire Widget display area.
    painter.eraseRect(rect());

    // Draw border around Widget display area.
    painter.setPen(Qt::darkGray);
    QRect rect(0, 0, width() - 1, height() - 1);
    painter.drawRect(rect);

    // If the selected channel is an amplifier channel, then write the channel name and number,
    // otherwise remind the user than non-amplifier channels cannot be displayed in Spike Scope.
    if (selectedChannel) {
        if (selectedChannel->signalType == AmplifierSignal) {
            painter.drawText(frame.right() - tbWidth - 1, frame.top() - tbHeight - 1,
                              tbWidth, tbHeight,
                              Qt::AlignRight | Qt::AlignBottom, selectedChannel->nativeChannelName);
            painter.drawText(frame.left() + 3, frame.top() - tbHeight - 1,
                              tbWidth, tbHeight,
                              Qt::AlignLeft | Qt::AlignBottom, selectedChannel->customChannelName);
        } else {
            painter.drawText(frame.right() - 2 * tbWidth - 1, frame.top() - tbHeight - 1,
                              2 * tbWidth, tbHeight,
                              Qt::AlignRight | Qt::AlignBottom, tr("ONLY AMPLIFIER CHANNELS CAN BE DISPLAYED"));
        }
    }

    // Label the voltage axis.
    painter.drawText(frame.left() - tbWidth - 2, frame.top() - 1,
                      tbWidth, tbHeight,
                      Qt::AlignRight | Qt::AlignTop,
                      "+" + QString::number(yScale) + " " + QSTRING_MU_SYMBOL + "V");
    painter.drawText(frame.left() - tbWidth - 2, frame.center().y() - tbHeight / 2,
                      tbWidth, tbHeight,
                      Qt::AlignRight | Qt::AlignVCenter, "0");
    painter.drawText(frame.left() - tbWidth - 2, frame.bottom() - tbHeight + 1,
                      tbWidth, tbHeight,
                      Qt::AlignRight | Qt::AlignBottom,
                      "-" + QString::number(yScale) + " " + QSTRING_MU_SYMBOL + "V");

    // Label the time axis.
    painter.drawText(frame.left() - tbWidth / 2, frame.bottom() + 1,
                      tbWidth, tbHeight,
                      Qt::AlignHCenter | Qt::AlignTop, "-1 ms");
    painter.drawText(frame.left() + (SPIKE_WINDOW_VLINE_1/SPIKE_WINDOW_T) * (frame.right() - frame.left()) + 1 - tbWidth / 2, frame.bottom() + 1,
                      tbWidth, tbHeight,
                      Qt::AlignHCenter | Qt::AlignTop, "-0.5 ms");
    painter.drawText(frame.left() + (SPIKE_WINDOW_VLINE_2/SPIKE_WINDOW_T) * (frame.right() - frame.left()) + 1 - tbWidth / 2, frame.bottom() + 1,
                      tbWidth, tbHeight,
                      Qt::AlignHCenter | Qt::AlignTop, "0 ms");
    painter.drawText(frame.left() + (SPIKE_WINDOW_VLINE_3/SPIKE_WINDOW_T) * (frame.right() - frame.left()) + 1 - tbWidth / 2, frame.bottom() + 1,
                      tbWidth, tbHeight,
                      Qt::AlignHCenter | Qt::AlignTop, "1 ms");
    painter.drawText(frame.right() - tbWidth + 1, frame.bottom() + 1,
                      tbWidth, tbHeight,
                      Qt::AlignRight | Qt::AlignTop, "2 ms");
    painter.end();
    update();

}
// Draw axis lines on the spike display
void SpikePlot::reDrawFSMLevels()
{
    reDrawText();
    reDrawAxesLines();

    QPainter painter(&pixmap);
    painter.initFrom(this);
    if (fsmModeOn == 1) {
        for (int ii = 0; ii < 8; ++ii) {
            if (wEnable.at(ii)) {
                if (ii == thisChannel) {
                    switch (wType.at(ii)) {
                        case 0:
                            painter.setPen(penThisInclude);
                            break;
                        case 1:
                            painter.setPen(penThisExclude);
                            break;
                        default:
                            painter.setPen(Qt::gray);
                    }
                } else {
                    switch (wType.at(ii)) {
                        case 0:
                            painter.setPen(penOtherInclude);
                            break;
                        case 1:
                            painter.setPen(penOtherExclude);
                            break;
                        default:
                            painter.setPen(Qt::gray);
                    }
                }
                painter.drawLine(levelStartPoint.at(ii),levelHeight.at(ii),levelStopPoint.at(ii),levelHeight.at(ii));
            }
        }
    }
    painter.end();
    update();

}

void SpikePlot::reDrawAxesLines()
{
    QPainter painter(&pixmap);
    painter.initFrom(this);
    painter.fillRect(frame, Qt::white);

    painter.setPen(Qt::darkGray);

    // Draw box outline.
    painter.drawRect(frame);

    // Draw horizonal zero voltage line.
    painter.drawLine(frame.left(), yOffset, frame.right(), yOffset);

    // Draw vertical lines
    painter.drawLine(tOffset + (SPIKE_WINDOW_VLINE_1/SPIKE_WINDOW_T) * tAxisLength, frame.top(),
                     tOffset + (SPIKE_WINDOW_VLINE_1/SPIKE_WINDOW_T) * tAxisLength, frame.bottom());
    painter.drawLine(tOffset + (SPIKE_WINDOW_VLINE_2/SPIKE_WINDOW_T) * tAxisLength, frame.top(),
                     tOffset + (SPIKE_WINDOW_VLINE_2/SPIKE_WINDOW_T) * tAxisLength, frame.bottom());
    painter.drawLine(tOffset + (SPIKE_WINDOW_VLINE_3/SPIKE_WINDOW_T) * tAxisLength, frame.top(),
                     tOffset + (SPIKE_WINDOW_VLINE_3/SPIKE_WINDOW_T) * tAxisLength, frame.bottom());
    painter.end();
    update();

}
// update the values to be used for drawing threshold lines on the spike plot
void SpikePlot::updateLevelStartStop()
{
    double intPoint;
    for (int i = 0; i < 8; i++){
        intPoint = double(preTriggerTSteps - (wMax - wStart.at(i)));
        levelStartPoint[i] = tOffset + intPoint * tScaleFactor;
        // Below, 1 represents transition from ACTIVE to TRIGGER;
        // 0.9 represents the fact that the leading edge (STOP) is
        // non-inclusive. However, we don't want to have levels with
        // ZERO width (need visual indicator) so that's why it is like that.
        intPoint = double(preTriggerTSteps - (wMax - wStop.at(i) + 1.9));
        levelStopPoint[i] = tOffset + intPoint * tScaleFactor;
        levelHeight[i] = yOffset + yScaleFactor * wThresh.at(i);
    }

    reDrawFSMLevels();
}

// Clear spike display.
void SpikePlot::clearScope()
{
    numSpikeWaveforms = 0;
    reDrawText();
    reDrawAxesLines();
}
// This function loads waveform data for the selected channel from the signal processor object,
// looks for trigger events, captures 4-ms snippets of the waveform after trigger events,
// measures the rms level of the waveform, and updates the display.
void SpikePlot::updateWaveform(int numBlocks)
{
    int i, index, index2;
    bool triggered, wTrigType;
    double rms;

    QPainter painter(&pixmap);
    painter.initFrom(this);

    // Make sure the selected channel is a valid amplifier channel
    if (!selectedChannel) return;
    if (selectedChannel->signalType != AmplifierSignal) return;

//    int stream = selectedChannel->boardStream;
//    int channel = selectedChannel->chipChannel;

    // Load recent waveform data and digital input data into our buffers.  Also, calculate
    // waveform RMS value.
    rms = 0.0;
    for (i = 0; i < SAMPLES_PER_DATA_BLOCK * numBlocks; ++i) {
//        spikeWaveformBuffer[i + totalTSteps - 1] = signalProcessor->amplifierPostFilter.at(stream).at(channel).at(i);
        spikeWaveformBuffer[i + totalTSteps - 1] = convertDac2Scope(signalProcessor->boardDac.at(thisChannel).at(i));
        rms += (spikeWaveformBuffer[i + totalTSteps - 1] * spikeWaveformBuffer[i + totalTSteps - 1]);
        digitalInputBuffer[i + totalTSteps - 1] =  signalProcessor->boardDigIn.at(digitalTriggerChannel).at(i);
        fsmTriggerBuffer[i + totalTSteps - 1] = signalProcessor->boardDigIn.at(FSM_DIG_TRIGGER_CHANNEL).at(i);
        fsmTrackerBuffer[i + totalTSteps - 1] = signalProcessor->boardDigIn.at(FSM_DIG_TRACKER_CHANNEL).at(i);
    }
    rms = qSqrt(rms / (SAMPLES_PER_DATA_BLOCK * numBlocks));

    // Find trigger events, and then copy waveform snippets to spikeWaveform vector.
    index = startingNewChannel ? (preTriggerTSteps + totalTSteps) : preTriggerTSteps;
    while (index <= SAMPLES_PER_DATA_BLOCK * numBlocks - 1  - preTriggerTSteps) {
        triggered = false;
        wTrigType = false;
        if (fsmModeOn) {

            if (fsmTriggerBuffer.at(index) == 1) { // Digital rising edge trigger (for "good spikes")
                triggered = true;
                wTrigType = true;
            } else if (fsmTrackerBuffer.at(index) == 0) { // Digital falling edge trigger (track "bad spikes" exiting FSM)
                if (fsmTrackerBuffer.at(index-1) == 1){
                    triggered = true;
                    wTrigType = false;
                }
            }
        } else {
            if (voltageTriggerMode) {
                if (voltageThreshold >= 0) {
                    // Positive voltage threshold trigger
                    if (spikeWaveformBuffer.at(index - 1) < voltageThreshold &&
                            spikeWaveformBuffer.at(index) >= voltageThreshold) {
                        triggered = true;
                    }
                } else {
                    // Negative voltage threshold trigger
                    if (spikeWaveformBuffer.at(index - 1) > voltageThreshold &&
                            spikeWaveformBuffer.at(index) <= voltageThreshold) {
                        triggered = true;
                    }
                }
            } else {
                if (digitalEdgePolarity) {
                    // Digital rising edge trigger
                    if (digitalInputBuffer.at(index - 1) == 0 &&
                            digitalInputBuffer.at(index) == 1) {
                        triggered = true;
                    }
                } else {
                    // Digital falling edge trigger
                    if (digitalInputBuffer.at(index - 1) == 1 &&
                            digitalInputBuffer.at(index) == 0) {
                        triggered = true;
                    }
                }
            }
        }
        // If we found a trigger event, grab waveform snippet.
        if (fsmModeOn) {
            if (triggered) {
                index2 = 0;
                if (wTrigType){
                    for (i = index - preTriggerTSteps;
                         i < index + totalTSteps - preTriggerTSteps; ++i) {
                        spikeWaveform[spikeWaveformIndex][index2++] = spikeWaveformBuffer.at(i - SAMPLE_DETECTION_DELAY);
                    }

                    fsmColors[colorIndex][spikeWaveformIndex] = 1;

                    if (++spikeWaveformIndex == spikeWaveform.size()) {
                        spikeWaveformIndex = 0;
                    }
                    if (++numSpikeWaveforms > maxNumSpikeWaveforms) {
                        numSpikeWaveforms = maxNumSpikeWaveforms;
                    }
                    index += totalTSteps - preTriggerTSteps;
                } else {
                    if (++badSpikeCounter == PLOT_BAD_SPIKE_EVERY_N){
                        badSpikeCounter = 0;
                        for (i = index - preTriggerTSteps;
                             i < index + totalTSteps - preTriggerTSteps; ++i) {
                            spikeWaveform[spikeWaveformIndex][index2++] = spikeWaveformBuffer.at(i - SAMPLE_DETECTION_DELAY);
                        }

                        fsmColors[colorIndex][spikeWaveformIndex] = 0;

                        if (++spikeWaveformIndex == spikeWaveform.size()) {
                            spikeWaveformIndex = 0;
                        }
                        if (++numSpikeWaveforms > maxNumSpikeWaveforms) {
                            numSpikeWaveforms = maxNumSpikeWaveforms;
                        }
                    }
                    ++index;

                }
            } else {
                ++index;
            }
        } else {
            if (triggered) {
                index2 = 0;
                for (i = index - preTriggerTSteps;
                     i < index + totalTSteps - preTriggerTSteps; ++i) {
                    spikeWaveform[spikeWaveformIndex][index2++] = spikeWaveformBuffer.at(i);
                }
                if (++spikeWaveformIndex == spikeWaveform.size()) {
                    spikeWaveformIndex = 0;
                }
                if (++numSpikeWaveforms > maxNumSpikeWaveforms) {
                    numSpikeWaveforms = maxNumSpikeWaveforms;
                }
                index += totalTSteps - preTriggerTSteps;
            } else {
                ++index;
            }
        }
    }

    // Copy tail end of waveform to beginning of spike waveform buffer, in case there is a spike
    // at the seam between two data blocks.
    index = 0;
    for (i = SAMPLES_PER_DATA_BLOCK * numBlocks - totalTSteps + 1;
         i < SAMPLES_PER_DATA_BLOCK * numBlocks; ++i) {
//        spikeWaveformBuffer[index++] = signalProcessor->amplifierPostFilter.at(stream).at(channel).at(i);
        spikeWaveformBuffer[index++] = convertDac2Scope(signalProcessor->boardDac.at(thisChannel).at(i));
    }

    if (startingNewChannel) {
        startingNewChannel = false;
    };

    painter.end();

    // Update plot.
    updateSpikePlot(rms);
}
// Plots spike waveforms and writes RMS value to display.
void SpikePlot::updateSpikePlot(double rms)
{
    int i, j, index;

    reDrawText();
    reDrawAxesLines();
    reDrawFSMLevels();

    QPainter painter(&pixmap);
    painter.initFrom(this);

    // Get text box width and height
    const int tbWidth = 180;
    const int tbHeight = painter.fontMetrics().height();

    // Vector for waveform plot points
    QPointF *polyline = new QPointF[totalTSteps];

    // Set clipping region for plotting.
    QRect adjustedFrame = frame;
    adjustedFrame.adjust(0, 1, 0, 0);
    painter.setClipRect(adjustedFrame);

    if (fsmModeOn) {
        for (j = 0; j < numSpikeWaveforms; ++j) {
            // Build waveform
            for (i = 0; i < totalTSteps; ++i) {
                polyline[i] = QPointF(tScaleFactor * i + tOffset, yScaleFactor * spikeWaveform.at(j).at(i) + yOffset);
            }

            // Draw waveform
            if (fsmColors.at(colorIndex).at(j)) {
                painter.setPen(penIncludeSpike);
            } else {
                painter.setPen(penExcludeSpike);
            }
            painter.drawPolyline(polyline, totalTSteps);
        }
    } else {
        index = maxNumSpikeWaveforms - numSpikeWaveforms;
        for (j = spikeWaveformIndex - numSpikeWaveforms; j < spikeWaveformIndex; ++j) {
            // Build waveform
            for (i = 0; i < totalTSteps; ++i) {
                polyline[i] = QPointF(tScaleFactor * i + tOffset, yScaleFactor * spikeWaveform.at((j+30) % spikeWaveform.size()).at(i) + yOffset);
            }

            // Draw waveform
            painter.setPen(scopeColors.at(colorIndex).at(index++));
            painter.drawPolyline(polyline, totalTSteps);
        }
    }

    // If using a voltage threshold trigger, plot a line at the threshold level.
    if (voltageTriggerMode && !fsmModeOn) {
        painter.setPen(Qt::red);
        painter.drawLine(tOffset, yScaleFactor * voltageThreshold + yOffset,
                         tScaleFactor * (totalTSteps - 1) +  tOffset, yScaleFactor * voltageThreshold + yOffset);
    }

    painter.setClipping(false);

    // Don't update the RMS value display every time, or it will change so fast that it
    // will be hard to read.  Only update once every few times we execute this function.
    if (rmsDisplayPeriod == 0) {
        rmsDisplayPeriod = 5;
        savedRMS = rms;
    } else {
        --rmsDisplayPeriod;
    }


    painter.setPen(Qt::darkGreen);
    painter.drawText(frame.left() + 6, frame.top() + 5,
                      tbWidth, tbHeight,
                      Qt::AlignLeft | Qt::AlignTop,
                      "RMS: " + QString::number(savedRMS, 'f', (savedRMS < 10.0) ? 1 : 0) +
                      " " + QSTRING_MU_SYMBOL + "V");

    painter.end();
    delete [] polyline;
    update();
}
// If user clicks inside display, set voltage threshold to that level.
void SpikePlot::mousePressEvent(QMouseEvent *event)
{
    if (event->button() == Qt::LeftButton) { // switch to include
        wType[thisChannel] = 0;
        emit(windowTypeChanged(0));
    } else if (event->button() == Qt::RightButton) { // switch to exclude
        wType[thisChannel] = 1;
        emit(windowTypeChanged(1));
    } else {
        QWidget::mousePressEvent(event);
        return;
    }

    if (frame.contains(event->pos())) {
        double newThreshold = getThresholdFromMousePress(event);
        setVoltageThreshold(newThreshold);
    }

}
// Parse voltage threshold from mouse press event
double SpikePlot::getThresholdFromMousePress(QMouseEvent *event)
{
    int yMouse = event->pos().y();
    double thresh = (yMouse - yOffset) / yScaleFactor;
    return thresh;
}
// Convert values from DAC to values on SCOPE
double SpikePlot::convertDac2Scope(double inData)
{
    // 0.195 uV per bit on AMPLIFIER
    // 0.0003125 mV per bit on DAC
    double outData = inData * (0.195/0.0003125);
    return outData;
}
// If user spins mouse wheel, change voltage scale.
void SpikePlot::wheelEvent(QWheelEvent *event)
{
    if (event->delta() > 0) {
        spikeScopeDialog->contractYScale();
    } else {
        spikeScopeDialog->expandYScale();
    }
}
// Keypresses to change voltage scale.
void SpikePlot::keyPressEvent(QKeyEvent *event)
{
    switch (event->key()) {
    case Qt::Key_Minus:
    case Qt::Key_Underscore:
        spikeScopeDialog->contractYScale();
        break;
    case Qt::Key_Plus:
    case Qt::Key_Equal:
        spikeScopeDialog->expandYScale();
        break;
    default:
        QWidget::keyPressEvent(event);
    }
}
QSize SpikePlot::minimumSizeHint() const
{
    return QSize(SPIKEPLOT_X_SIZE, SPIKEPLOT_Y_SIZE);
}
QSize SpikePlot::sizeHint() const
{
    return QSize(SPIKEPLOT_X_SIZE, SPIKEPLOT_Y_SIZE);
}
void SpikePlot::paintEvent(QPaintEvent * /* event */)
{
    QStylePainter stylePainter(this);
    stylePainter.drawPixmap(0, 0, pixmap);
}
void SpikePlot::closeEvent(QCloseEvent *event)
{
    // Perform any clean-up here before application closes.
    event->accept();
}


// Set the number of spikes that are plotted, superimposed, on the
// display.
void SpikePlot::setMaxNumSpikeWaveforms(int num)
{
    maxNumSpikeWaveforms = num;
    clearScope();

    switch (maxNumSpikeWaveforms) {
        case 10: colorIndex = 0; break;
        case 20: colorIndex = 1; break;
        case 30: colorIndex = 2; break;
    }
}
// Select voltage threshold trigger mode if voltageMode == true, otherwise
// select digital input trigger mode.
void SpikePlot::setVoltageTriggerMode(bool voltageMode)
{
    voltageTriggerMode = voltageMode;
    if (selectedChannel->signalType == AmplifierSignal) {
        selectedChannel->voltageTriggerMode = voltageMode;
    }
    updateSpikePlot(0.0);
}

// Set voltage threshold trigger level.  We use integer threshold
// levels (in microvolts) since there is no point going to fractional
// microvolt accuracy.
void SpikePlot::setVoltageThreshold(int threshold)
{
    if (threshold < -5000 || threshold > 5000) {
        cerr << "Error in SpikePlot::setVoltageThreshold: threshold (" << threshold << ") out of range." << endl;
        return;
    }

    if (!fsmModeOn) {
        if (selectedChannel->signalType == AmplifierSignal) {
            emit(currentVoltageThresholdChanged(threshold));
        }
    } else {
        emit(currentVoltageThresholdChanged(threshold));
    }
    voltageThreshold = threshold;

}

// Select digital input channel for digital input trigger.
void SpikePlot::setDigitalTriggerChannel(int channel)
{
    digitalTriggerChannel = channel;
    if (selectedChannel->signalType == AmplifierSignal) {
        selectedChannel->digitalTriggerChannel = channel;
    }
}

// Set digitial trigger edge polarity to rising or falling edge.
void SpikePlot::setDigitalEdgePolarity(bool risingEdge)
{
    digitalEdgePolarity = risingEdge;
    if (selectedChannel->signalType == AmplifierSignal) {
        selectedChannel->digitalEdgePolarity = risingEdge;
    }
}


// Change to a new signal channel.
void SpikePlot::setNewChannel(SignalChannel* newChannel)
{
    selectedChannel = newChannel;
    numSpikeWaveforms = 0;
    startingNewChannel = true;
    rmsDisplayPeriod = 0;

    voltageTriggerMode = selectedChannel->voltageTriggerMode;
    voltageThreshold = selectedChannel->voltageThreshold;
    digitalTriggerChannel = selectedChannel->digitalTriggerChannel;
    digitalEdgePolarity = selectedChannel->digitalEdgePolarity;

    initSpikeAxes();
}

void SpikePlot::resizeEvent(QResizeEvent*) {
    // Pixel map used for double buffering.
    pixmap = QPixmap(size());
    pixmap.fill();
    initSpikeAxes();
}

// INIT - Functions to collapse other stuff... //
void SpikePlot::initGenProperties()
{
    // initialize new properties
    fsmModeOn = false;
    wEnable.resize(8);
    wStart.resize(8);
    wStop.resize(8);
    wType.resize(8);
    wThresh.resize(8);
    wThresh.fill(0);

    wEnable.fill(false);
    for (int i = 0; i < 4; i++){
        wEnable[i] = true;
    }
    wMax = 5;
    levelStartPoint.resize(8);
    levelStartPoint.fill(0.0);
    levelStopPoint.resize(8);
    levelStopPoint.fill(0.0);
    levelHeight.resize(8);
    levelHeight.fill(0.0);
    thisChannel = 0;

    for (int i = 0; i < 8; i++){
        wStart[i] = i;
        wStop[i] = i + 2;
        wType[i] = i % 2;
    }

    fsmStart = 0.0;
    frameY = 0.0;
    tAxisLength = 0.0;
    yAxisLength = 0.0;
    yScaleFactor = 0.0;
    yScale = 1000;

    switch (maxNumSpikeWaveforms) {
        case 10: colorIndex = 0; break;
        case 20: colorIndex = 1; break;
        case 30: colorIndex = 2; break;
    }
    // END

    voltageTriggerMode = true;
    voltageThreshold = 0;
    digitalTriggerChannel = 0;
    digitalEdgePolarity = true;

    savedRMS = 0;

}
// initialize buffers for plotting snippets
void SpikePlot::initBuffers()
{
    startingNewChannel = true;
    rmsDisplayPeriod = 0;
    savedRMS = 0.0;

    spikeWaveformIndex = 0;
    numSpikeWaveforms = 0;
    maxNumSpikeWaveforms = 20;

    // We can plot up to 30 superimposed spike waveforms on the scope.
    spikeWaveform.resize(maxNumSpikeWaveforms);
    int i;
    for (i = 0; i < spikeWaveform.size(); ++i) {
        // Each waveform is 3 ms in duration.  We need 91 time steps for a 3 ms
        // waveform with the sample rate is set to its maximum value of 30 kS/s.
        spikeWaveform[i].resize(totalTSteps);
        spikeWaveform[i].fill(0.0);
    }

    // Buffers to hold recent history of spike waveform and digital input,
    // used to find trigger events.
    spikeWaveformBuffer.resize(BUFFER_SIZE);
    spikeWaveformBuffer.fill(0.0);
    digitalInputBuffer.resize(BUFFER_SIZE);
    digitalInputBuffer.fill(0);
    fsmTriggerBuffer.resize(BUFFER_SIZE);
    fsmTriggerBuffer.fill(0);
    fsmTrackerBuffer.resize(BUFFER_SIZE);
    fsmTrackerBuffer.fill(0);
}
// pens for different kinds of spikes, etc.
void SpikePlot::initPenColors()
{
    // These pens are for "good" vs "bad" spikes and for
    // different types of thresholds
    // (blue -> include)
    // (red -> exclude)
    // (thick -> current channel; thin -> other windows)
    penThisInclude.setWidth(4);
    penThisInclude.setBrush(Qt::blue);
    penThisExclude.setWidth(4);
    penThisExclude.setBrush(Qt::red);

    penOtherInclude.setWidth(2);
    penOtherInclude.setBrush(Qt::blue);
    penOtherExclude.setWidth(2);
    penOtherExclude.setBrush(Qt::red);

    penIncludeSpike.setWidth(2);
    penIncludeSpike.setBrush(Qt::darkBlue);

    penExcludeSpike.setWidth(1);
    penExcludeSpike.setBrush(Qt::lightGray);

    // Set up vectors of varying plot colors so that older waveforms
    // are plotted in low-contrast gray and new waveforms are plotted
    // in high-contrast blue.  Older signals fade away, like phosphor
    // traces on old-school CRT oscilloscopes.
    scopeColors.resize(3);
    scopeColors[0].resize(10);
    scopeColors[1].resize(20);
    scopeColors[2].resize(30);

    for (int i = 6; i < 10; ++i) scopeColors[0][i] = Qt::black;
    for (int i = 3; i < 6; ++i) scopeColors[0][i] = Qt::darkGray;
    for (int i = 0; i < 3; ++i) scopeColors[0][i] = Qt::lightGray;

    for (int i = 12; i < 20; ++i) scopeColors[1][i] = Qt::black;
    for (int i = 6; i < 12; ++i) scopeColors[1][i] = Qt::darkGray;
    for (int i = 0; i < 6; ++i) scopeColors[1][i] = Qt::lightGray;

    for (int i = 18; i < 30; ++i) scopeColors[2][i] = Qt::black;
    for (int i = 9; i < 18; ++i) scopeColors[2][i] = Qt::darkGray;
    for (int i = 0; i < 9; ++i) scopeColors[2][i] = Qt::lightGray;

    fsmColors.resize(3);
    fsmColors[0].resize(10);
    fsmColors[0].fill(false);
    fsmColors[1].resize(20);
    fsmColors[1].fill(false);
    fsmColors[2].resize(30);
    fsmColors[2].fill(false);

    colorIndex = 1;
}
// initialize display properties for the spike dialog window
void SpikePlot::initDisplay()
{
    pixmap = QPixmap(size());
    pixmap.fill();

    setBackgroundRole(QPalette::Window);
    setAutoFillBackground(true);
    setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Preferred);
    setFocusPolicy(Qt::StrongFocus);

}
// set up the axes for plotting spikes
void SpikePlot::initSpikeAxes() {

    const int tbWidth = fontMetrics().width("+" + QString::number(yScale) + " " + QSTRING_MU_SYMBOL + "V");
    const int tbHeight = fontMetrics().height();
    const double centerPoint = SPIKE_WINDOW_VLINE_2 / SPIKE_WINDOW_T;

    frame = rect();
    frame.adjust(tbWidth + 5, tbHeight + 10, -8, -tbHeight - 10);

    tOffset = frame.left();
    fsmStart = tOffset + centerPoint * (tAxisLength);

    yAxisLength = (frame.height() - 2) / 2.0;
    yScaleFactor = -yAxisLength / yScale;
    yOffset = frame.center().y();

    tScale = SPIKE_WINDOW_T;  // time scale = 3.0 ms
    tAxisLength = frame.right() - frame.left();
    tScaleFactor = tAxisLength * tStepMsec / tScale;


    // Initialize display.
    reDrawText();
    reDrawAxesLines();
    updateLevelStartStop();
}
